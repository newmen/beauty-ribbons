class CurrentUsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :setup_current_user

  add_default_breadcrumbs_and_call_filter

  # GET /current_users/edit
  def edit
    add_edit_breadcrumb
  end

  # PUT /current_users
  def update
    if @user.update_with_password(params[:user])
      redirect_to control_panel_url,
                  notice: I18n.t('controller.success_update', model: I18n.t('activerecord.models.user'))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  private

  def setup_current_user
    @user = current_user
  end

  def add_breadcrumbs
    add_control_panel_breadcrumb
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t('current_users.edit.title')
  end

end
