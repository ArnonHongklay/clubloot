class Entities::ProgramTemplateContestsExpose < Grape::Entity
  expose :id
  expose :name
  # expose :template #, with: ProgramTemplatesShowExpose

  expose :contests do |item|
    item.template
  end
end
