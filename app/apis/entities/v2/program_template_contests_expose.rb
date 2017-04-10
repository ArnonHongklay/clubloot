class Entities::V2::ProgramTemplateContestsExpose < Grape::Entity
  expose :id
  expose :name
  # expose :template #, with: ProgramTemplatesShowExpose
  expose :contests, with: Entities::V2::ProgramTemplatesContestsExpose
end
