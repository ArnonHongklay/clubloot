class Entities::V1::PrizesExpose < Grape::Entity
  expose :id
  expose :attachment
  expose :name
  expose :description
  expose :price
end
