class BadgesController < ApplicationController
  before_action :authenticate_user!

  add_default_breadcrumbs_and_call_filter except: :destroy

  def index
    @badges = Badge.all
  end

  def new
    add_create_breadcrumb
    @badge = Badge.new
  end

  def edit
    add_edit_breadcrumb
    @badge = Badge.find(params[:id])
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      redirect_to badges_url,
                  notice: I18n.t("controller.success_create", model: I18n.t("activerecord.models.badge"))
    else
      add_create_breadcrumb
      render :new
    end
  end

  def update
    @badge = Badge.find(params[:id])
    if @badge.update(badge_params)
      redirect_to badges_url,
                  notice: I18n.t("controller.success_update", model: I18n.t("activerecord.models.badge"))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  def destroy
    @badge = Badge.find(params[:id])
    @badge.destroy
    redirect_to badges_url,
                notice: I18n.t("controller.success_destroy", model: I18n.t("activerecord.models.badge"))
  end

  private

  def badge_params
    params.fetch(:badge, {}).permit(:name, :color, :position, :identifier)
  end

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t("badges.index.title"), badges_path
  end

  def add_create_breadcrumb
    add_breadcrumb I18n.t("badges.new.title")
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t("badges.edit.title")
  end
end
