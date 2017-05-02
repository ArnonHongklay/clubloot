class Entities::V3::ProgramExpose < Grape::Entity
  expose :id { |i| i.id.to_s }
  expose :name
  expose :category
  expose :attachment
end
