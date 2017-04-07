class DefaultAPI < Grape::API
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token

  # Follow: http://dreamingechoes.github.io/api/ruby/rails/create-a-super-fancy-api-with-grape/
  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  helpers do
    def api_response response
      present :status, response[:status]
      present :data, response[:data]
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
      # return true if warden.authenticated?
      # params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])

      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def current_user
      # access_token = request.headers['Authorization'] || params[:token]
      access_token = params[:token]
      token = ApiKey.where(access_token: access_token).first
      if token && !token.expired?
        @current_user = User.find(token.user_id)
      else
        false
      end

      # warden.user || @user
    end

    def warden
      env['warden']
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error_response(message: e.message, status: 404)
  end

  # rescue_from ActiveRecord::RecordInvalid do |e|
  #   error_response(message: e.message, status: 422)
  # end

  mount ApiV1
  mount ApiV2

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
    mount_path: 'docs',
    # base_path: '/',
    security_definitions: {
      api_key: {
        type: "apiKey",
        name: "api_key",
        in: "header"
      }
    }
    # models: ::Entities.constants.select { | c | Class === ::Entities.const_get(c) }
    #                         .map { | c | "::Entities::V1::#{c.to_s}".constantize }
end
