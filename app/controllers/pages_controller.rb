class PagesController < ApplicationController
  before_action :authenticate_user!, except: :show

  add_default_breadcrumbs_and_call_filter except: :show

  def index
    @pages = Page.all
  end

  def show
    @page = Page.find_by(identifier: params[:identifier])
    add_breadcrumb @page.title, "/#{params[:identifier]}"
  end

  def edit
    add_edit_breadcrumb
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update(page_params)
      redirect_to control_panel_url,
                  notice: I18n.t("controller.success_update", model: I18n.t("activerecord.models.page"))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  private

  def page_params
    params.fetch(:page, {}).permit(:title, :markdown)
  end

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t("pages.index.title"), pages_path
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t("pages.edit.title")
  end
end
