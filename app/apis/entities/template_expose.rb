class Entities::TemplateExpose < Grape::Entity
  expose :_id
  expose :name
  expose :questions
end
