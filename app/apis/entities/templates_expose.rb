class Entities::TemplatesExpose < Grape::Entity
  expose :_id
  expose :name
  expose :upcoming_time

  expose :templates, with: ProgramTemplatesShowExpose
end
