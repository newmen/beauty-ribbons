class ColorsController < ApplicationController
  before_action :authenticate_user!

  add_default_breadcrumbs_and_call_filter except: :destroy

  def index
    @colors = Color.rainbow
  end

  def new
    add_create_breadcrumb
    @color = Color.new
  end

  def edit
    add_edit_breadcrumb
    @color = Color.find(params[:id])
  end

  def create
    @color = Color.new(color_params)
    if @color.save
      redirect_to colors_url,
                  notice: I18n.t("controller.success_create", model: I18n.t("activerecord.models.color"))
    else
      add_create_breadcrumb
      render :new
    end
  end

  def update
    @color = Color.find(params[:id])
    if @color.update(color_params)
      redirect_to colors_url,
                  notice: I18n.t("controller.success_update", model: I18n.t("activerecord.models.color"))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  def destroy
    @color = Color.find(params[:id])
    @color.destroy
    redirect_to colors_url,
                notice: I18n.t("controller.success_destroy", model: I18n.t("activerecord.models.color"))
  end

  private

  def color_params
    params.fetch(:color, {}).permit(:name, :value)
  end

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t("colors.index.title"), colors_path
  end

  def add_create_breadcrumb
    add_breadcrumb I18n.t("colors.new.title")
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t("colors.edit.title")
  end
end
