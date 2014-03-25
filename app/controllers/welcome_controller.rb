class WelcomeController < ApplicationController
  include CartHelper

  before_filter :find_products, only: :index

  def initialize
    super
    @products_limit ||= Settings.counts.welcome_products.to_i
  end

  def index
    @page = Page.welcome
  end

  private

  def find_products
    not_ordered_scope =
      if has_stored_products?
        Product.not_product_ids(stored_product_ids)
      else
        Product.scoped
      end

    @products = []
    @products += not_ordered_scope.novelties.limit_random(1)
    @products += not_ordered_scope.sales.limit_random(1) if @products_limit > 1

    if @products.size < @products_limit
      @products += missing_products(not_ordered_scope.not_archived)
    end

    if @products.size < @products_limit
      @products += missing_products(Product.scoped)
    end

    @products.shuffle!
  end

  def missing_products(scope)
    scope.not_products(@products).limit_random(@products_limit - @products.size)
  end
end
