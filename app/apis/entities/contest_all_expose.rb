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
  expose :upcoming_time do |item|
    item.template.end_time
  end
end
