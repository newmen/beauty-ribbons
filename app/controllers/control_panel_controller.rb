class ControlPanelController < ApplicationController
  before_action :authenticate_user!

  add_root_breadcrumb

  def index
    add_control_panel_breadcrumb
  end
end
