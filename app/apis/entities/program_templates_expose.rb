class Entities::ProgramTemplatesExpose < Grape::Entity
  expose :id
  # expose :attachment
  # expose :category
  expose :name
  expose :upcoming_time
  expose :templates, with: ProgramTemplatesShowExpose
end
