class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  embedded_in :question
end
