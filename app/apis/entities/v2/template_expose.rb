class Entities::V2::TemplateExpose < Grape::Entity
  expose :id
  expose :name
  expose :active
  expose :number_answers
  expose :number_questions

  expose :program_name do |item|
    item.program.name
  end

  expose :questions, with: Entities::V2::QuestionExpose

  expose :created_at
  expose :updated_at
  # expose :is_correct
  expose :end_time
end
