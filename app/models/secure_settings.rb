class SecureSettings < Settingslogic
  source "#{Rails.root}/config/secure_settings.yml"
  namespace Rails.env

  class << self
    def setup_action_mailer(action_mailer)
      action_mailer.default_url_options = { host: Settings.domain_name }

      # Change mail delivery to either :smtp, :sendmail, :file, :test
      action_mailer.delivery_method = :smtp
      action_mailer.smtp_settings = {
        address: 'smtp.gmail.com',
        port: 587,
        domain: Settings.domain_name,
        authentication: 'plain',
        enable_starttls_auto: true,
        user_name: gmail.username,
        password: gmail.password
      }
    end
  end
end
