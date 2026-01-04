require_relative "boot"

require "rails/all"

begin
  require "dotenv/load"
rescue LoadError
  # Dotenv is optional; skip loading if the gem isn't available (e.g., production)
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PageChat
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Enable full Rails stack so Trestle admin can render HTML responses.
    config.api_only = false
    config.generators do |g|
      g.test_framework(:rspec, fixture: false, views: false, helper: false)

      # g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
