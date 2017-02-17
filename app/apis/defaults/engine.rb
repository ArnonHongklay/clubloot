module Defaults
  module Engine
    extend ActiveSupport::Concern

    included do
      # prefix "api"
      version 'v1', using: :path
      default_format :json
      format :json
      formatter :json, Grape::Formatter::ActiveModelSerializers
    end
  end
end
