module V1
  class PrizesAPI < Grape::API
    # extend Defaults::Engine

    resource :prizes do
      get '/' do
        begin
          prizes = Prize.all
          if prizes
            present :status, :success
            if prizes.present?
              present :data, prizes, with: Entities::PrizesExpose
            else
              present :data, prizes
            end
          else
            present :status, :failure
            present :data, "Can't show data"
          end
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
