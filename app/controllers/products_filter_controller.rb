class ProductsFilterController < ApplicationController
  def self.filter_scopes(options)
    has_scope :tags, options
    has_scope :colors, options
    has_scope :min_price, options
    has_scope :max_price, options
    has_scope :sort_by, options.merge(default: Settings.sorting.default) do |controller, scope, value|
      field_name, direct = value.split('-')
      if Settings.sorting.fields.include?(field_name)
        field_name = 'price_cents' if field_name == 'price'
        direct = 'asc' unless direct == 'asc' || direct == 'desc'
        scope.order("products.#{field_name} #{direct.upcase}")
      else
        scope
      end
    end

    # :only and :except options don't work when before_render calling in self.method as here
    before_render do
      current_action = action_name.to_sym
      return if !options[:only].include?(current_action) || options[:except].include?(current_action)
      @all_products = apply_scopes(@products).include_refs
      @products = @all_products.page(params[:page].to_i || 1)
    end
  end
end
