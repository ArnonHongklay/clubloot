class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :is_correct,  type: Integer
  field :name,        type: String

  embeds_many :answers
  embedded_in :template
end
