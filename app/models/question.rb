class Question
  include Mongoid::Document

  field :title, type: String
  field :templates, type: BSON::ObjectId
  field :answers, type: Array
end
