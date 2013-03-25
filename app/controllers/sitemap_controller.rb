class SitemapController < ApplicationController
  caches_page :index

  add_default_breadcrumbs_and_call_filter only: :show

  before_filter :find_products_and_scopes

  def index
    @static_paths = [root_path, delivery_path]

    @category_paths = @product_static_scopes + Category.all.map(&:slug)
    @category_paths.map! { |scope_name| "/#{scope_name}" }
  end

  def show
    @delivery_page = Page.delivery
    @categories = Category.all
  end

  private

  def find_products_and_scopes
    @products = Product.includes(:category)
    @product_static_scopes = Product::STATIC_SCOPES.select { |scope_name| Product.send(scope_name).exists? }
  end

  def add_breadcrumbs
    add_breadcrumb I18n.t('sitemap.show.title'), sitemap_page_path
  end

end
