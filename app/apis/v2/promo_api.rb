module V2
  class PromoAPI < Grape::API

    resource :users do
      params do
        optional :user_id, type: String, desc: "User Id"
      end
      get '/' do
        begin
          present :status, :success
          present :data, User.all, with: Entities::V2::UserAllExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
