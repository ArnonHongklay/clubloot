class Entities::ProgramTemplatesShowExpose < Grape::Entity
  expose :id
  expose :name
  expose :start_time
  expose :end_time
  # expose :start_time do |item|
  #   item.start_time.utc.iso8601
  # end
  # expose :end_time do |item|
  #   item.end_time.utc.iso8601
  # end
end
