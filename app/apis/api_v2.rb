class ApiV2 < ApplicationAPI
  extend ActiveSupport::Concern

  # prefix "v2"
  # version 'v2', using: :accept_version_header
  default_format :json
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  resource :v2 do
    mount V2::AuthAPI
    # mount V2::UsersAPI
    # mount V2::ContestsAPI
    # mount V2::PrizesAPI
  end
end
