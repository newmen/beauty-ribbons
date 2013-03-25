class ApplicationController < ActionController::Base
  protect_from_forgery

  before_render :breadcrumbs_for_wiselinks

  private

  def after_sign_in_path_for(_user)
    control_panel_path
  end

  def self.add_default_breadcrumbs_and_call_filter(options = {})
    add_root_breadcrumb
    before_filter :add_breadcrumbs, options
  end

  def self.add_root_breadcrumb
    add_breadcrumb I18n.t('welcome.index.title'), :root_path
  end

  def add_control_panel_breadcrumb
    add_breadcrumb I18n.t('control_panel.index.title'), control_panel_path
  end

  def add_cart_breadcrumb
    add_breadcrumb I18n.t('cart.show.title'), cart_path
  end

  def breadcrumbs_for_wiselinks
    if self.request.wiselinks?
      crumbs = view_context.render_wisebreadcrumbs.to_str
      Wiselinks.log("breadcrumbs: #{crumbs}")
      self.response.headers['X-Wiselinks-Breadcrumbs'] = URI.encode(crumbs)
    end
  end

end
