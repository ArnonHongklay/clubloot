class Entities::V2::QuestionExpose < Grape::Entity
  expose :_id
  expose :is_correct
  expose :name
  expose :answers, with: Entities::V2::AnswerExpose
end
