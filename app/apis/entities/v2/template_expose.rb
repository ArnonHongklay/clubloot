class Entities::V2::TemplateExpose < Grape::Entity
  expose :_id
  expose :name
  expose :program_name do |item|
    item.program.name
  end

  expose :questions, with: Entities::V2::QuestionExpose
end
