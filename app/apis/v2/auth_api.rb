module V2
  class AuthAPI < Grape::API

    resource :auth do
      desc "Creates and return access_token if valid signup"
      params do
        requires :email, type: String, desc: "email address", regexp: /.+@.+/
        requires :password, type: String, desc: "Password"
        requires :confirm_password, type: String, desc: "Confirm Passoword"
        requires :username, type: String, desc: "Username"
        requires :date_of_birth, type: String, desc: "Username"
        optional :promo, type: String, desc: "promo code"
      end
      post :sign_up do
        begin
          api_response({ status: :failure, data: 'not @' }) unless params[:email].include?("@")
          api_response({ status: :failure, data: 'email is already' }) unless User.where(email: params[:email].downcase).exists?

          if params[:password].present? and params[:username].present?
            if params[:password] == params[:confirm_password]
              # if Promo.available?(params[:promo])
              #   promo = Promo.where(code: params[:promo])
              # else
              #   promo = nil
              # end
              promo = Promo.where(code: params[:promo]).first
              user = User.create!(email: params[:email], username: params[:username], password: params[:password], date_of_birth: params[:date_of_birth], promo: promo)
              api_response({ status: :success, data: user })
            else
              api_response({ status: :failure, data: "password not match" })
            end
          else
            api_response({ status: :failure, data: "data input is wrong" })
          end
        rescue Exception => e
          api_response({ status: :failure, data: e })
        end
      end

      desc "Creates and returns access_token if valid signin"
      params do
        requires :email, type: String, desc: "email address"
        requires :password, type: String, desc: "Password"
      end
      post :sign_in do
        api_response({ status: :failure, data: 'not @' }) unless params[:email].include?("@")

        user = User.find_by(email: params[:email].downcase)
        if user && user.valid_password?(params[:password])
          key = ApiKey.create(user_id: user.id)
          { token: key.access_token }
        else
          error!('Unauthorized.', 401)
        end
      end

      desc "Returns pong if logged in correctly"
      params do
        requires :token, type: String, desc: "Access token."
      end
      get :ping do
        authenticate!
        { message: current_user }
      end
    end
  end
end
