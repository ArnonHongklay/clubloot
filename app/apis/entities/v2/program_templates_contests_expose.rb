class Entities::V2::ProgramTemplatesContestsExpose < Grape::Entity
  expose :id
  expose :name
  expose :max_players
  expose :status
  expose :state
  expose :prize
  expose :fee
  expose :public

  expose :host, with: Entities::V2::UserAllExpose
  expose :template #, with: ProgramTemplatesShowExpose
  expose :players
  # expose :quizes
end
