class AddDefaultUser < ActiveRecord::Migration[7.2]
  DEFAULT_PASSWORD = "password"

  def up
    return if find_default_user

    User.create!(
      email: default_email,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  def down
    return unless (user = find_default_user)

    user.destroy
  end

  private

  def default_email
    SecureSettings.admin_email
  end

  def find_default_user
    User.find_by(email: default_email)
  end
end
