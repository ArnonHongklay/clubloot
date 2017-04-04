module V2
  class AuthAPI < Grape::API

    resource :auth do
      desc ""
      params do
      end
      post :sign_up do

      end

      desc "Creates and returns access_token if valid signin"
      params do
        requires :email, type: String, desc: "email address"
        requires :password, type: String, desc: "Password"
      end
      post :sign_in do
        binding.pry
        if params[:email].include?("@")
          user = User.find_by(email: params[:email].downcase)
        # else
        #   user = User.find_by(login: params[:login].downcase)
        end

        if user && user.authenticate(params[:password])
          key = ApiKey.create(user_id: user.id)
          {token: key.access_token}
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
        { message: "pong" }
      end
    end
  end
end
