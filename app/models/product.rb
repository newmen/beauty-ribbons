class Product < ActiveRecord::Base
  paginates_per Settings.counts.products_per_page.to_i

  attr_accessible :category_id, :name, :description, :width, :height, :length, :diameter,
                  :cover_id, :product_image_ids, :tag_list, :color_ids,
                  :price, :old_price, :badge_id, :is_archived

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :category
  belongs_to :badge
  has_and_belongs_to_many :colors, uniq: true
  has_and_belongs_to_many :tags, uniq: true
  belongs_to :cover, class_name: ProductImage
  has_many :product_images, dependent: :destroy
  has_and_belongs_to_many :orders

  monetize :price_cents
  monetize :old_price_cents, allow_nil: true
  validates_presence_of :category, :cover, :name, :price
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :old_price, greater_than: 0, allow_nil: true
  validates_numericality_of :height, :width, :length, :diameter, greater_than: 0, allow_nil: true

  scope :limit_random, -> limit { order_by_rand.limit(limit) }

  scope :include_refs, -> { includes(:category).includes(:cover) }
  scope :not_product_ids, -> ids { ids.empty? ? scoped : where('id NOT IN (?)', ids) }
  scope :not_products, -> products { not_product_ids(products.map(&:id)) }
  scope :not_archived, -> { where(is_archived: false) }

  STATIC_SCOPES = %w(novelties sales archived)
  scope :archived, -> { where(is_archived: true) }
  scope :novelties, -> { not_archived.where('products.created_at > ?', Time.at(Time.now.to_i - Settings.nova_seconds)) }
  scope :sales, -> { not_archived.where('old_price_cents IS NOT NULL AND old_price_cents > price_cents') }

  scope :min_price, -> value { where('price_cents >= ?', value.to_i * 100) }
  scope :max_price, -> value { where('price_cents <= ?', value.to_i * 100) }

  class << self
    def tags(tag_ids_str)
      filter_scope(Tag, tag_ids_str)
    end

    def colors(color_ids_str)
      filter_scope(Color, color_ids_str)
    end

    def filter_subquery(model_name, secure_ids_str, what_select)
      sing_assoc_name = model_name.to_s.underscore
      ref_table_name = ['products', sing_assoc_name.pluralize].sort.join('_')
      "SELECT #{what_select} FROM #{ref_table_name} " \
      "WHERE #{ref_table_name}.product_id = #{table_name}.id " \
      "AND #{ref_table_name}.#{sing_assoc_name}_id IN (#{secure_ids_str})"
    end

    private

    def secure_ids_str_with_nums(ids_str)
      secure_ids = ids_str.split(',').compact.map(&:to_i).reject { |id| id == 0 }
      [secure_ids.map(&:to_s).join(','), secure_ids.size]
    end

    def filter_scope(model_name, ids_str)
      secure_ids_str, num = secure_ids_str_with_nums(ids_str)
      where("EXISTS (#{filter_subquery(model_name, secure_ids_str, 1)}) " \
            "AND (#{filter_subquery(model_name, secure_ids_str, 'COUNT(*)')}) == #{num}")
    end
  end

  # TODO: возможно стоит вынести в декоратор (которого пока ещё нет)
  def badge
    return nil if is_archived
    current_badge = super
    Badge.defaults.each do |default_badge|
      break if current_badge && default_badge.position < current_badge.position

      case(default_badge.identifier)
      when 'nova'
        current_badge = default_badge if (Time.now - created_at).to_i < Settings.nova_seconds
      when 'sale'
        current_badge = default_badge if old_price && old_price > price
      end
    end
    current_badge
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |tag|
      tag = tag.strip
      next if tag.blank?
      Tag.where(name: tag).first_or_create!
    end.compact
  end

  def similar
    limit = Settings.counts.similar_products.to_i
    tag_ids_str = tag_ids.join(',')
    color_ids_str = color_ids.join(',')
    not_self_scope = Product.where('id != ?', id)

    similar_products = not_self_scope.not_archived.where(
      "(EXISTS (#{self.class.filter_subquery(Tag, tag_ids_str, 1)})) OR " \
      "(EXISTS (#{self.class.filter_subquery(Color, color_ids_str, 1)}))"
    ).select(
      'products.*, ' \
      "((#{self.class.filter_subquery(Tag, tag_ids_str, 'COUNT(*)')}) + " \
      "(#{self.class.filter_subquery(Color, color_ids_str, 'COUNT(*)')})) as similar_count"
    ).order('similar_count DESC').limit(limit).to_a

    not_similars = -> scope do
      scope.not_products(similar_products).limit_random(limit - similar_products.size)
    end

    if similar_products.size < limit
      similar_products += not_similars[not_self_scope.where(category_id: category_id).not_archived]
    end

    if similar_products.size < limit
      similar_products += not_similars[not_self_scope.not_archived]
    end

    if similar_products.size < limit
      similar_products += not_similars[not_self_scope]
    end

    similar_products
  end

  def has_sizes?
    width || height || length || diameter
  end
end
