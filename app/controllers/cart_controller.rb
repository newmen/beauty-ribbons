class CartController < ApplicationController
  include RefererStore
  include CartHelper

  store_referer_except :cart, :order, only: :show

  before_filter :find_product, only: [:create, :destroy]

  add_default_breadcrumbs_and_call_filter only: :show

  def show
    unless has_stored_products?
      redirect_to referer_url, alert: I18n.t('controller.no_stored_products')
    end
  end

  def create
    stored_product_ids << @product.id unless stored_product_ids.include?(@product.id)
  end

  def destroy
    stored_product_ids.delete(@product.id)
  end

  private

  def find_product
    @product = Product.find(params[:product_slug])
  end

  def add_breadcrumbs
    add_cart_breadcrumb
  end
end
