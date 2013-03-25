class ColorsController < ApplicationController
  before_filter :authenticate_user!

  add_default_breadcrumbs_and_call_filter except: :destroy

  # GET /colors
  def index
    @colors = Color.rainbow
  end

  # GET /colors/new
  def new
    add_create_breadcrumb
    @color = Color.new
  end

  # GET /colors/1/edit
  def edit
    add_edit_breadcrumb
    @color = Color.find(params[:id])
  end

  # POST /colors
  def create
    @color = Color.new(params[:color])
    if @color.save
      redirect_to colors_url,
                  notice: I18n.t('controller.success_create', model: I18n.t('activerecord.models.color'))
    else
      add_create_breadcrumb
      render :new
    end
  end

  # PUT /colors/1
  def update
    @color = Color.find(params[:id])
    if @color.update_attributes(params[:color])
      redirect_to colors_url,
                  notice: I18n.t('controller.success_update', model: I18n.t('activerecord.models.color'))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  # DELETE /colors/1
  def destroy
    @color = Color.find(params[:id])
    @color.destroy
    redirect_to colors_url,
                notice: I18n.t('controller.success_destroy', model: I18n.t('activerecord.models.color'))
  end

  private

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t('colors.index.title'), colors_path
  end

  def add_create_breadcrumb
    add_breadcrumb I18n.t('colors.new.title')
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t('colors.edit.title')
  end

end
