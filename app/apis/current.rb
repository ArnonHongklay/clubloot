class Current < ApplicationAPI
  extend ActiveSupport::Concern

  # prefix "api"
  version '', using: :path
  default_format :json
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  mount V2::AuthAPI
  mount V2::UsersAPI
  mount V2::ContestsAPI
  mount V2::PrizesAPI
end
