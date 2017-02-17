module V1
  class TemplatesAPI < Grape::API
    extend Defaults::Engine
    # use Rack::JSONP
    helpers do
      params :token do
        optional :token, type: String, default: nil
      end
      params :attributes do
        optional :attributes, type: Hash, default: {}
      end
    end

    resource :template do
      params do
        requires :email,    type: String, desc: "email of the user"
        requires :password, type: String, desc: "password of the user"
      end
      post "/signup" do
        begin
          user = User.create!(email: params[:email], password: params[:password])
          present :status, :success
          present :data, user, with: Entities::AuthExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end


    end
  end
end
