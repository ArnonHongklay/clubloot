class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :is_correct,  type: String, default: :false
  field :name,        type: String

  embeds_many :answers
  embedded_in :template
end
