class Program
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  has_many :templates

  field :name,      type: String
  field :category,  type: String
  field :active,    type: Boolean, default: false

  scope :active,    -> { where(active: true) }
  scope :pending,   -> { where(active: false) }
end
