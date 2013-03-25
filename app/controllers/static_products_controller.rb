class StaticProductsController < ProductsFilterController
  Product::STATIC_SCOPES.each do |scope_name|
    has_scope scope_name, type: :boolean, only: :index
  end

  filter_scopes only: :index

  add_root_breadcrumb

  # GET /products
  def index
    @products = Product.scoped
    current_scope = Product::STATIC_SCOPES.find { |scope_name| params[scope_name] }
    @title = I18n.t("static_products.#{current_scope}")
    add_breadcrumb @title, "/#{current_scope}"
    render 'categories/show'
  end
end