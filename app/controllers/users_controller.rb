class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_rules

  add_default_breadcrumbs_and_call_filter except: :destroy

  def index
    @users = User.all
  end

  def new
    add_create_breadcrumb
    @user = User.new
  end

  def edit
    add_edit_breadcrumb
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_url,
                  notice: I18n.t("controller.success_create", model: I18n.t("activerecord.models.user"))
    else
      add_create_breadcrumb
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_url,
                  notice: I18n.t("controller.success_update", model: I18n.t("activerecord.models.user"))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url,
                notice: I18n.t("controller.success_destroy", model: I18n.t("activerecord.models.user"))
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:email, :password, :password_confirmation)
  end

  def check_admin_rules
    unless current_user.admin?
      redirect_to control_panel_url, alert: I18n.t("controller.you_are_not_root")
    end
  end

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t("users.index.title"), users_path
  end

  def add_create_breadcrumb
    add_breadcrumb I18n.t("users.new.title")
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t("users.edit.title")
  end
end
