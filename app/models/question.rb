class Question
  include Mongoid::Document

  field :_id,         type: BSON::ObjectId
  field :template_id, type: BSON::ObjectId
  field :title,       type: String
  field :answers,     type: Array
end
