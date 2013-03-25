# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'user@example.com'
    password 'password'
    password_confirmation 'password'

    factory :logged_user do
      current_password 'password'
    end
  end

  factory :admin, class: User do
    email SecureSettings.admin_email
    password 'password'
  end
end
