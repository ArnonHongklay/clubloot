class Entities::V1::ProgramTemplateContestsExpose < Grape::Entity
  expose :id
  expose :name
  # expose :template #, with: ProgramTemplatesShowExpose
  expose :contests, with: Entities::V1::ProgramTemplatesContestsExpose
end
