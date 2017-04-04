module Defaults
  module Engine
    extend ActiveSupport::Concern

    included do
      prefix "api"
      version 'v1', using: :path
      default_format :json
      format :json
      formatter :json, Grape::Formatter::ActiveModelSerializers

      error_formatter :json, API::ErrorFormatter
    end
  end
end
