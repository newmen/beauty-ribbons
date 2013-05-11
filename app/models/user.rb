class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # , :registerable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def admin?
    email == SecureSettings.admin_email
  end

end
