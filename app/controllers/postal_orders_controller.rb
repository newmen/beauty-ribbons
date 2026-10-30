class PostalOrdersController < ApplicationController
  include CartHelper

  before_action :authenticate_user!, except: [:new, :create]

  add_default_breadcrumbs_and_call_filter except: [:new, :create]

  def index
    @postal_orders = PostalOrder.all
  end

  def new
    if ordered_products
      add_create_breadcrumb
      @postal_order = PostalOrder.new
    else
      redirect_to cart_url, alert: I18n.t("controller.no_stored_products")
    end
  end

  def edit
    add_edit_breadcrumb
    @postal_order = PostalOrder.find(params[:id])
  end

  def create
    render_with_errors = -> do
      add_create_breadcrumb
      render :new
    end

    @postal_order = PostalOrder.new(postal_order_params)
    if !ordered_products
      redirect_to cart_url, alert: I18n.t("controller.postal_orders_products_have_changed")
    elsif !ids_corresponds_to_products(params[:ordered_products], ordered_products)
      flash[:alert] = I18n.t("controller.postal_orders_products_have_changed")
      render_with_errors.call
    else
      @postal_order.products = ordered_products
      if @postal_order.save
        unstore_products(ordered_products)
        redirect_to root_url, notice: I18n.t("controller.thanks_for_order")
      else
        render_with_errors.call
      end
    end
  end

  def update
    @postal_order = PostalOrder.find(params[:id])
    if @postal_order.update(postal_order_params)
      redirect_to postal_orders_url,
                  notice: I18n.t("controller.success_update", model: I18n.t("activerecord.models.postal_order"))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  private

  def postal_order_params
    params.fetch(:postal_order, {}).permit(
      :username, :email, :zipcode, :country, :region, :city, :street_line,
      :comment, :note, :amount
    )
  end

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t("postal_orders.index.title"), postal_orders_path
  end

  def add_create_breadcrumb
    add_cart_breadcrumb
    add_breadcrumb I18n.t("postal_orders.new.title")
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t("postal_orders.edit.title")
  end
end
