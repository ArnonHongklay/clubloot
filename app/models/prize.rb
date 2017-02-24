class Prize
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name,        type: String
  field :price,       type: Integer
  field :quantity,    type: Integer
  field :picture,     type: String
  field :description, type: String
  field :active,      type: Boolean
  field :count,       type: Integer

  has_mongoid_attached_file :attachment
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }
end
