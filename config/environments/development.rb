Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false

  config.consider_all_requests_local = true
  config.server_timing = true

  config.action_controller.perform_caching = false
  config.cache_store = :memory_store

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  config.assets.debug = true
  config.assets.quiet = true

  config.i18n.raise_on_missing_translations = true

  SecureSettings.setup_action_mailer(config.action_mailer)
end
