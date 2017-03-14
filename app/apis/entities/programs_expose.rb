class Entities::ProgramsExpose < Grape::Entity
  expose :_id
  expose :attachment
  expose :category
  expose :name
  expose :upcoming_time
end
