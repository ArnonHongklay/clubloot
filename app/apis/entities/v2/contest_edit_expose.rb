class Entities::V2::ContestEditExpose < Grape::Entity
  expose :id
  expose :name
  expose :quizes
  # expose :template do |item|
  #   item.template
  # end
end
