class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  has_scope :page, only: :index, default: 1

  add_default_breadcrumbs_and_call_filter except: [:destroy, :show]

  def index
    @products = apply_scopes(Product.order("id DESC")).include_refs
  end

  def show
    @product = category.products.friendly.find(params[:slug])
    if request.path != polymorphic_path([category, @product])
      redirect_to [category, @product], status: :moved_permanently
    else
      b_title = b_path = nil
      if request.referer && request.referer[root_url]
        r = request.referer.dup
        r[root_url] = ""
        slug, url_tail = r.split("?")
        if Product::STATIC_SCOPES.include?(slug)
          b_title = I18n.t("static_products.#{slug}")
        elsif referred_category = Category.where("slug = ?", slug).first
          b_title = referred_category.name
        end

        if b_title
          if url_tail.blank?
            b_path = "/#{slug}"
          else
            b_title << I18n.t("actions.filtered")
            b_path = "/#{slug}?#{url_tail}"
          end
        end
      end
      add_breadcrumb(b_title || category.name, b_path || "/#{category.slug}")
      add_breadcrumb(@product.name, "/#{category.slug}/#{@product.slug}")
    end
  end

  def new
    add_create_breadcrumb
    @product = params[:category_slug] ? category.products.new : Product.new
  end

  def edit
    add_edit_breadcrumb
    @product = category.products.friendly.find(params[:slug])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to [@product.category, @product],
                  notice: I18n.t("controller.success_create", model: I18n.t("activerecord.models.product"))
    else
      add_create_breadcrumb
      render :new
    end
  end

  def update
    @product = Product.friendly.find(params[:id])
    if @product.update(product_params)
      redirect_to [@product.category, @product],
                  notice: I18n.t("controller.success_update", model: I18n.t("activerecord.models.product"))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  def destroy
    @product = Product.friendly.find(params[:slug])
    @product.destroy
    redirect_to @product.category,
                notice: I18n.t("controller.success_destroy", model: I18n.t("activerecord.models.product"))
  end

  private

  def product_params
    params.fetch(:product, {}).permit(
      :category_id, :name, :description, :width, :height, :length, :diameter,
      :cover_id, :tag_list, :price, :old_price, :badge_id, :is_archived,
      product_image_ids: [], color_ids: []
    )
  end

  def category
    @category ||= Category.friendly.find(params[:category_slug])
  end

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t("products.index.title"), products_path
  end

  def add_create_breadcrumb
    add_breadcrumb I18n.t("products.new.title")
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t("products.edit.title")
  end
end
