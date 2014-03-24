Devise.setup do |config|

  config.secret_key = '11111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000022222222222222222222222'

  config.mailer_sender = SecureSettings.contacts.email
  config.email_regexp = BeautyRibbons::Application.email_regexp

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
