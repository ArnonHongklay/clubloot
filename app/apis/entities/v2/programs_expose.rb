class Entities::V2::ProgramsExpose < Grape::Entity
  expose :id
  expose :attachment
  expose :category
  expose :name
  expose :upcoming_time
end
