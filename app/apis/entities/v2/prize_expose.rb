class Entities::V2::PrizeExpose < Grape::Entity
  expose :prizes, with: Entities::V2::PrizesExpose
end
