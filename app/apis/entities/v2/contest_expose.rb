class Entities::V2::ContestExpose < Grape::Entity
  expose :id
  expose :name
  # expose :max_players
  # expose :status
  # expose :state
  # expose :prize
  # expose :fee
  # expose :public
  # expose :template do |item|
  #   item.template
  # end
  # expose :players do |item|
  #   item.players
  # end
end
