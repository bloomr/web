require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bloomr
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr

    config.active_job.queue_adapter = :delayed_job

    config.middleware.insert_before 0, "Rack::Cors", :debug => true, :logger => (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '*',
                 :headers => :any,
                 :methods => [:get, :options, :head],
                 :max_age => 86400
      end
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['SMTP_ADDRESS'],
      port:                 587,
      domain:               ENV['SMTP_DOMAIN'],
      user_name:            ENV['SMTP_USER_NAME'],
      password:             ENV['SMTP_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: true  }

    config.action_mailer.default_url_options = { host: ENV['MAILER_URL'] }

    config.active_record.raise_in_transactional_callbacks = true
  end
end
