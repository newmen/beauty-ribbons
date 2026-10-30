class User < ActiveRecord::Base
  attr_accessor :current_password

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable

  def admin?
    email == SecureSettings.admin_email
  end
end
