class PreOrdersController < ApplicationController
  include CartHelper

  before_filter :authenticate_user!, except: [:new, :create]

  add_default_breadcrumbs_and_call_filter except: [:new, :create]

  # GET /pre_orders
  def index
    @pre_orders = PreOrder.all
  end

  # GET /pre_orders/new
  def new
    if desired_products
      add_create_breadcrumb
      @pre_order = PreOrder.new
    else
      redirect_to cart_url, alert: I18n.t('controller.no_stored_products')
    end
  end

  # GET /pre_orders/1/edit
  def edit
    add_edit_breadcrumb
    @pre_order = PreOrder.find(params[:id])
  end

  # POST /pre_orders
  def create
    @pre_order = PreOrder.new(params[:pre_order])
    if !desired_products || !ids_corresponds_to_products(params[:desired_products], desired_products)
      redirect_to cart_url, notice: I18n.t('controller.pre_orders_products_have_changed')
    elsif @pre_order.valid?
      @pre_order.products = desired_products
      @pre_order.save
      unstore_products(desired_products)
      redirect_to root_url, notice: I18n.t('controller.thanks_for_order')
    else
      add_create_breadcrumb
      render :new
    end
  end

  # PUT /pre_orders/1
  def update
    @pre_order = PreOrder.find(params[:id])
    if @pre_order.update_attributes(params[:pre_order])
      redirect_to pre_orders_url,
                  notice: I18n.t('controller.success_update', model: I18n.t('activerecord.models.pre_order'))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  private

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t('pre_orders.index.title'), pre_orders_path
  end

  def add_create_breadcrumb
    add_cart_breadcrumb
    add_breadcrumb I18n.t('pre_orders.new.title')
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t('pre_orders.edit.title')
  end

end
