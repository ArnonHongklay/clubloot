class Winner
  include Mongoid::Document

  field :_id,         type: BSON::ObjectId
  field :user_id,     type: BSON::ObjectId
  field :contest_id,  type: BSON::ObjectId
  field :template_id, type: BSON::ObjectId
  field :prize,       type: Integer
end
