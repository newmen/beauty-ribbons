class ProductFilter < ActiveRecord::Base
  self.abstract_class = true

  attr_accessible :name

  # has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true

  class << self
    def most_common(products)
      ref_table_name = ['products', table_name].sort.join('_')
      ref_self_id = "#{ref_table_name}.#{self.to_s.underscore}_id"
      joins("INNER JOIN #{ref_table_name} ON #{ref_self_id} = #{table_name}.id").
        where("#{ref_table_name}.product_id" => products.map(&:id)).
        select("#{table_name}.*, COUNT(#{ref_self_id}) as count").
        group("#{ref_self_id}").
        order('count DESC').
        limit(Settings.counts.send("common_#{table_name}"))
    end
  end

end