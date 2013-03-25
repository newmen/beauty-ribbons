class ControlPanelController < ApplicationController
  before_filter :authenticate_user!

  add_root_breadcrumb

  def index
    add_control_panel_breadcrumb
  end
end
