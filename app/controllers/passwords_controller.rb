class PasswordsController < Devise::PasswordsController
  add_default_breadcrumbs_and_call_filter

  private

  def add_breadcrumbs
    add_breadcrumb I18n.t('passwords.edit.title')
  end
end
