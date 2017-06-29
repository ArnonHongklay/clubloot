module V2
  class AdvertAPI < Grape::API
    resource :adverts do
      get '/' do
        begin
          ads = Advert.where(:daily_at.gte => Time.zone.now.beginning_of_day, :daily_at.lte => Time.zone.now.end_of_day)

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
