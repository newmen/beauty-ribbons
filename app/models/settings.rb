class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env

  class << self
    def nova_seconds
      3600 * 24 * nova_days.to_i
    end
  end
end
