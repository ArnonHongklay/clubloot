class Advert
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :description, type: String
  field :daily_at, type: Date

  has_mongoid_attached_file :attachment, :default_url => "#{App.domain}/no-image.png"
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }

  # validates :description, :daily_at, :attachment, presence: true
end
