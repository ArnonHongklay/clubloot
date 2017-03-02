class Entities::TemplateExpose < Grape::Entity
  expose :_id
  expose :name
  expose :program_name do |item|
    item.program.name
  end
  expose :questions
end
