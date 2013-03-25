class SessionsController < Devise::SessionsController
  add_default_breadcrumbs_and_call_filter only: :new

  private

  def add_breadcrumbs
    add_breadcrumb I18n.t('sessions.new.breadcrumb')
  end
end