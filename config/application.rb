require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clubloot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Pacific Time (US & Canada)'
    # config.active_record.default_timezone = :local
    # config.active_record.time_zone_aware_types = [:datetime, :time]
    # config.active_record.raise_in_transactional_callbacks = true

    config.exceptions_app = self.routes
    config.paperclip_defaults = {
      storage:              :s3,
      s3_host_name:         "s3-us-west-1.amazonaws.com",
      s3_protocol:          "https",
      url:                  ":s3_domain_url",
      path:                 "/:class/:attachment/:id_partition/:style/:filename",
      s3_credentials: {
        bucket:             ENV.fetch("S3_BUCKET_NAME"),
        access_key_id:      ENV.fetch("AWS_ACCESS_KEY_ID"),
        secret_access_key:  ENV.fetch("AWS_SECRET_ACCESS_KEY"),
        s3_region:          ENV.fetch("AWS_REGION"),
      }
    }

  end
end
