class Contest
  include Mongoid::Document

  field :_id,           type: BSON::ObjectId
  field :template_id,   type: BSON::ObjectId
  field :program_id,    type: BSON::ObjectId
  field :program_name,  type: String
  field :user_id,       type: BSON::ObjectId
  field :owner,         type: String
  field :name,          type: String
  field :max_player,    type: Integer

  field :status,        type: String
  field :stage,         type: String
  field :challenge,     type: Integer

  field :player,        type: Array
  field :participant,   type: Array
  field :loot,          type: Array

  field :start_time,    type: DateTime
  field :end_time,      type: DateTime
end
