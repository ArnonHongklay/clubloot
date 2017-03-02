class Entities::ProgramsExpose < Grape::Entity
  expose :_id
  expose :attachment
  expose :category
  expose :name
  expose :start_time
end
