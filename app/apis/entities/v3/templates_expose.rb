class Entities::V3::TemplatesExpose < Grape::Entity
  expose :id { |i| i.id.to_s }
  expose :name
  expose :start_time
  expose :end_time
  expose :program, with: Entities::V3::ProgramExpose
  expose :questions, with: Entities::V3::QuestionsExpose
end
