class ApiV3 < ApplicationAPI
  extend ActiveSupport::Concern

  # prefix "v2"
  # version 'v2', using: :accept_version_header
  default_format :json
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  resource :v3 do
    mount V3::ContestsAPI
  end
end
