<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  add_default_breadcrumbs_and_call_filter except: :destroy

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
  end

  # GET <%= route_url %>/1
  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  # GET <%= route_url %>/new
  def new
    add_create_breadcrumb
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
    add_edit_breadcrumb
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>
    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>,
                  <%= key_value :notice, "I18n.t('controller.success_create', model: I18n.t('activerecord.models.#{singular_table_name}'))" %>
    else
      add_create_breadcrumb
      render :new
    end
  end

  # PUT <%= route_url %>/1
  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
      redirect_to @<%= singular_table_name %>,
                  <%= key_value :notice, "I18n.t('controller.success_update', model: I18n.t('activerecord.models.#{singular_table_name}'))" %>
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url,
                <%= key_value :notice, "I18n.t('controller.success_destroy', model: I18n.t('activerecord.models.#{singular_table_name}'))" %>
  end

  private

  def add_breadcrumbs
    add_breadcrumb I18n.t('<%= plural_table_name %>.index.title'), <%= index_helper %>_path
  end

  def add_create_breadcrumb
    add_breadcrumb I18n.t('<%= plural_table_name %>.new.title')
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t('<%= plural_table_name %>.edit.title')
  end
end
<% end -%>
