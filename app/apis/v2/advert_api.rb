module V2
  class AdvertAPI < Grape::API
    resource :adverts do
      # params do
      #   optional :user_id, type: String, desc: "User Id"
      # end
      get '/' do
        begin
          ads = Advert.where(:daily_at.gte => Time.zone.now, :daily_at.lte => 1.days.from_now)

          present :status, :success
          present :data, ads, with: Entities::V2::AdvertExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
