class ApiV1 < ApplicationAPI
  extend ActiveSupport::Concern

  # prefix "v1"
  # version 'v1', using: :accept_version_header
  default_format :json
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  resource :v1 do
    mount V1::UsersAPI
    mount V1::ContestsAPI
    mount V1::PrizesAPI
  end
end
