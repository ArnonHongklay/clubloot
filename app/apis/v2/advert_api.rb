module V2
  class AdvertAPI < Grape::API
    resource :adverts do
      # params do
      #   optional :user_id, type: String, desc: "User Id"
      # end
      get '/' do
        begin
          ads = Advert.where(:start_date.lte => Time.zone.now, :end_date.gte => Time.zone.now)

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
