class WelcomeController < ApplicationController
  include CartHelper

  before_filter :find_products, only: :index

  def index
    @page = Page.welcome
  end

  private

  def find_products
    not_ordered_scope =
      if has_stored_products?
        Product.where('id NOT IN (?)', stored_product_ids)
      else
        Product.scoped
      end
    products_limit = Settings.counts.welcome_products.to_i
    @products = []
    @products << not_ordered_scope.novelties.order_by_rand
    @products << not_ordered_scope.sales.order_by_rand if products_limit > 1
    @products.compact!

    missing_products = -> scope do
      scope.not_products(@products).order_by_rand(products_limit - @products.size)
    end

    if @products.size < products_limit
      @products += missing_products[not_ordered_scope.not_archived]
    end

    if @products.size < products_limit
      @products += missing_products[Product.scoped]
    end

    @products.shuffle!
  end
end
