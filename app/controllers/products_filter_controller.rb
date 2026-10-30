class ProductsFilterController < ApplicationController
  def self.filter_scopes(options)
    has_scope :tags, options
    has_scope :colors, options
    has_scope :min_price, options
    has_scope :max_price, options
    has_scope :sort_by, options.merge(default: Settings.sorting.default) do |controller, scope, value|
      field_name, direct = value.split("-")
      if Settings.sorting.fields.include?(field_name)
        field_name = "price_cents" if field_name == "price"
        direct = "asc" unless direct == "asc" || direct == "desc"
        scope.order("products.#{field_name} #{direct.upcase}")
      else
        scope
      end
    end

    before_render do
      current_action = action_name.to_sym
      next if options[:only] && !options[:only].include?(current_action)
      next if options[:except] && options[:except].include?(current_action)

      @all_products = apply_scopes(@products).include_refs
      @products = @all_products.page(params[:page].to_i || 1)
    end
  end
end
