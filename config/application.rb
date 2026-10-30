require_relative "boot"

require "rails/all"
require_relative "../lib/app_settings"
require_relative "../lib/extras/referer_store"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BeautyRibbons
  class Application < Rails::Application
    config.load_defaults 7.2

    def self.email_regexp
      /\A(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+))*[A-Za-z0-9]+@(([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+))*[A-Za-z0-9]{2,63}\.([a-zA-Z]{2}|com|org|net|edu|gov|mil|biz|pro|info|mobi|name|aero|asia|jobs|museum)\Z/
    end

    config.autoload_lib(ignore: %w[assets tasks templates app_settings.rb extras])

    config.active_storage.service = :local

    config.time_zone = "Moscow"
    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.filter_parameters += [:password]

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.template_engine :haml
    end
  end
end
