class ledger
  include Mongoid::Document

  field :_id,         type: BSON::ObjectId
  field :user_id,     type: BSON::ObjectId
end
