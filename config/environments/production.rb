Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.cache_store = :file_store, Rails.root.join("tmp/cache")

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  config.assets.compile = false
  config.assets.digest = true
  config.assets.js_compressor = :terser

  config.log_level = :info
  config.log_tags = [:request_id]

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false

  SecureSettings.setup_action_mailer(config.action_mailer)
end
