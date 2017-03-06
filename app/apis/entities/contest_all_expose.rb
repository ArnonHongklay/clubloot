class Entities::ContestAllExpose < Grape::Entity
  expose :name
  expose :max_players
  expose :status
  expose :state
  expose :active
  expose :fee
  expose :prize
  expose :public
  expose :host
  expose :players
  expose :template
  expose :winners
  expose :program do |item|
    item.template.program
  end
  # expose :players do |item|
  #   item.players
  # end
end
