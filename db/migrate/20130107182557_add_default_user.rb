class AddDefaultUser < ActiveRecord::Migration
  DEFAULT_EMAIL = SecureSettings.admin_email
  DEFAULT_PASSWORD = 'password'

  def up
    return if find_default_user
    User.create(email: DEFAULT_EMAIL, password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD)
  end

  def down
    return unless (user = find_default_user)
    user.destroy
  end

  private

  def find_default_user
    User.find_by_email(DEFAULT_EMAIL)
  end
end
