class DefaultAPI < Grape::API
  extend ActiveSupport::Concern

  # Follow: http://dreamingechoes.github.io/api/ruby/rails/create-a-super-fancy-api-with-grape/
  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  helpers do
    def api_response response
      case response
      when Integer
        status response
      when String
        response
      when Hash
        response
      when Net::HTTPResponse
        "#{response.code}: #{response.message}"
      else
        status 400 # Bad request
      end
    end

    def permitted_params
      @permitted_params ||= declared(params, include_missing: false)
    end

    def clean_params(params)
      ActionController::Parameters.new(params)
    end

    def logger
      Rails.logger
    end

    # https://mikecoutermarsh.com/rails-grape-api-key-authentication/
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def current_user
      # token = ApiKey.where(access_token: params[:token]).first
      # if token && !token.expired?
      #   @current_user = User.find(token.user_id)
      # else
      #   false
      # end
      warden.user || @user
    end

    def warden
      env['warden']
    end

    def authenticated
      return true if warden.authenticated?
      params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error_response(message: e.message, status: 404)
  end

  # rescue_from ActiveRecord::RecordInvalid do |e|
  #   error_response(message: e.message, status: 422)
  # end

  # mount V1::AuthAPI
  # mount V1::UsersAPI
  # mount V1::ContestsAPI
  # mount V1::PrizesAPI
  # mount V1::Root
  mount ApiV1

  add_swagger_documentation \
    api_version: '1.0.0',
    hide_documentation_path: true,
    hide_format: true,
    # markdown: false,
    info: {
      contact: 'clubloot@gmail.com',
      terms_of_service_url: 'https://clubloot.com/terms',
      title: 'Clubloot API'
    },
    include_base_url: true,
    mount_path: '/v1',
    base_path: '/',
    security_definitions: {
      api_key: {
        type: "apiKey",
        name: "api_key",
        in: "header"
      }
    }
    # models: ::Entities.constants.select { | c | Class === ::Entities.const_get(c) }
    #                         .map { | c | "::Entities::#{c.to_s}".constantize }
end
