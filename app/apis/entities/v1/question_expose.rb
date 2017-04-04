class Entities::V1::QuestionExpose < Grape::Entity
  expose :_id
  expose :is_correct
  expose :name
  expose :answers, with: Entities::V1::AnswerExpose
end
