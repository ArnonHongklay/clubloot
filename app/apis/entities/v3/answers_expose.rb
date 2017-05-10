class Entities::V3::AnswersExpose < Grape::Entity
  expose :id { |i| i.id.to_s }
  expose :name
  expose :attachment
end
