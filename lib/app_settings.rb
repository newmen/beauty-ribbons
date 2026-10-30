require "yaml"
require "erb"

module AppSettings
  class Section < Hash
    def initialize(values = {})
      super()
      values.each { |key, value| self[key] = value }
    end

    def default(*args)
      return self["default"] if key?("default")

      super
    end

    def method_missing(name, *args, &block)
      key = name.to_s
      return super unless key?(key)

      self[key]
    end

    def respond_to_missing?(name, include_private = false)
      key?(name.to_s) || super
    end

    def []=(key, value)
      super(key.to_s, value.is_a?(Hash) ? Section.new(value) : value)
    end

    def to_hash
      Hash[self]
    end
  end

  def self.load(path, namespace, fallback_path = nil)
    source = File.exist?(path) ? path : fallback_path
    raise Errno::ENOENT, "No settings file found at #{path}" unless source && File.exist?(source)

    contents = ERB.new(File.read(source)).result
    data = YAML.safe_load(contents, permitted_classes: [Date, Time, Symbol], aliases: true) || {}
    Section.new(data[namespace.to_s] || data["defaults"] || {})
  end
end

class Settings
  class << self
    def source
      @source ||= Rails.root.join("config/settings.yml").to_s
    end

    def namespace
      @namespace ||= Rails.env.to_s
    end

    def instance
      @instance ||= AppSettings.load(source, namespace)
    end

    def load!
      instance
      true
    end

    def reload!
      @instance = nil
      load!
    end

    def [](key)
      instance[key]
    end

    def []=(key, value)
      instance[key] = value
    end

    def get(key)
      key.to_s.split(".").inject(instance) do |scope, part|
        scope.public_send(part)
      end
    end

    def nova_seconds
      3600 * 24 * nova_days.to_i
    end

    def method_missing(name, *args, &block)
      return super unless instance.respond_to?(name)

      instance.public_send(name, *args, &block)
    end

    def respond_to_missing?(name, include_private = false)
      instance.respond_to?(name, include_private) || super
    end
  end
end

class SecureSettings
  class << self
    def source
      @source ||= Rails.root.join("config/secure_settings.yml").to_s
    end

    def fallback_source
      @fallback_source ||= Rails.root.join("config/secure_settings_gag.yml").to_s
    end

    def namespace
      @namespace ||= Rails.env.to_s
    end

    def instance
      @instance ||= AppSettings.load(source, namespace, fallback_source)
    end

    def load!
      instance
      true
    end

    def reload!
      @instance = nil
      load!
    end

    def [](key)
      instance[key]
    end

    def get(key)
      key.to_s.split(".").inject(instance) do |scope, part|
        scope.public_send(part)
      end
    end

    def setup_action_mailer(action_mailer)
      action_mailer.default_url_options = { host: Settings.domain_name }

      action_mailer.delivery_method = :smtp
      action_mailer.smtp_settings = {
        address: "smtp.gmail.com",
        port: 587,
        domain: Settings.domain_name,
        authentication: "plain",
        enable_starttls_auto: true,
        user_name: gmail.username,
        password: gmail.password
      }
    end

    def method_missing(name, *args, &block)
      return super unless instance.respond_to?(name)

      instance.public_send(name, *args, &block)
    end

    def respond_to_missing?(name, include_private = false)
      instance.respond_to?(name, include_private) || super
    end
  end
end
