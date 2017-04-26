class Entities::V2::PrizeExpose < Grape::Entity
  expose :prize, with: Entities::V2::PrizesExpose
end
