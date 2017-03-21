class Entities::ProgramTemplateContestsExpose < Grape::Entity
  expose :id
  expose :name
  # expose :template #, with: ProgramTemplatesShowExpose
  expose :contests, with: Entities::ProgramTemplatesContestsExpose
end
