class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  class_attribute :before_render_callbacks, default: []

  def self.before_render(callback = nil, &block)
    self.before_render_callbacks = before_render_callbacks + [block || callback]
  end

  def self.add_default_breadcrumbs_and_call_filter(options = {})
    add_root_breadcrumb
    before_action :add_breadcrumbs, options
  end

  def self.add_root_breadcrumb
    add_breadcrumb I18n.t("welcome.index.title"), :root_path
  end

  def render(*args, &block)
    run_before_render_callbacks
    super
  end

  private

  def run_before_render_callbacks
    self.class.before_render_callbacks.each do |callback|
      callback.is_a?(Proc) ? instance_exec(&callback) : send(callback)
    end
  end

  def after_sign_in_path_for(_user)
    control_panel_path
  end

  def add_control_panel_breadcrumb
    add_breadcrumb I18n.t("control_panel.index.title"), control_panel_path
  end

  def add_cart_breadcrumb
    add_breadcrumb I18n.t("cart.show.title"), cart_path
  end
end
