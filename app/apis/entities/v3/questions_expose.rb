class Entities::V3::QuestionsExpose < Grape::Entity
  expose :id { |i| i.id.to_s }
  expose :is_correct
  expose :name
  expose :answers, with: Entities::V3::AnswersExpose do |item|
    item.answers.select{|a| a.name.present? }
  end
end
