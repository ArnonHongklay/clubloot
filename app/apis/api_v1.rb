class ApiV1 < ApplicationAPI
  extend ActiveSupport::Concern

  # prefix "api"
  version 'v1', using: :path
  default_format :json
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  # error_formatter :json, API::ErrorFormatter

  mount V1::AuthAPI
  mount V1::UsersAPI
  mount V1::ContestsAPI
  mount V1::PrizesAPI
end
