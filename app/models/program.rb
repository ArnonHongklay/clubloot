class Program
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  has_many :templates

  field :name,      type: String
  field :category,  type: String
  field :active,    type: Boolean, default: false

  has_mongoid_attached_file :attachment
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }

  scope :active,    -> { where(active: true) }
  scope :pending,   -> { where(active: false) }
end
