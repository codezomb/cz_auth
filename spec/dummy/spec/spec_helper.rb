ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../../config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'generator_spec'
require 'json_spec'
require 'database_cleaner'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include JsonSpec::Helpers

  # Run tests in a random order
  config.order = "random"

  #
  # Run this before each test
  #
  config.before :suite do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  #
  # Run this after all tests
  #
  config.after do
    DatabaseCleaner.clean
  end
end