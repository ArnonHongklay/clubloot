class Entities::V2::PrizeExpose < Grape::Entity
  expose :name
  expose :price
  expose :quantity
  expose :description
  expose :active
  expose :count
  expose :prize, with: Entities::V2::PrizesExpose
end
