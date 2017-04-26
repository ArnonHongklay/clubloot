class Entities::V2::PrizeExpose < Grape::Entity
  expose :tracking_code
  expose :carrier
  expose :status
  expose :shipped_at
  expose :prize, with: Entities::V2::PrizesExpose
end
