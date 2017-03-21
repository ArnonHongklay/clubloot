class Entities::ProgramContestsExpose < Grape::Entity
  expose :id
  expose :name
  # expose :max_players
  expose :status
  expose :state
  expose :prize
  expose :fee
  expose :public

  expose :host
  expose :template #, with: ProgramTemplatesShowExpose
  expose :players
  # expose :quizes
end
