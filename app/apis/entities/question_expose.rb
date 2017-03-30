class Entities::QuestionExpose < Grape::Entity
  expose :_id
  expose :is_correct
  expose :name
  expose :answers, with: Entities::AnswerExpose
end
