class Entities::ProgramsExpose < Grape::Entity
  expose :_id
  expose :attachment
  expose :category
  expose :name
end
