ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:should, :expect]
    mocks.verify_partial_doubles = false
  end

  config.include FactoryBot::Syntax::Methods
  config.include ActionView::Helpers::UrlHelper, type: :controller

  [:controller, :view, :helper].each do |type|
    config.include Devise::Test::ControllerHelpers, type: type
  end

  config.include MailerHelper, type: :mailer
  config.include HelperHelper, type: :helper
  config.include HelperHelper, type: :view

  %w(model view controller mailer).each do |component|
    config.extend "#{component.classify}Examples".constantize, type: component.to_sym
  end

  config.use_transactional_fixtures = false
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
