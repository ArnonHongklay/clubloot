class Advert
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :description, type: String
  field :daily_at, type: DateTime
  field :start_date, type: DateTime
  field :end_date, type: DateTime

  has_mongoid_attached_file :attachment, :default_url => "#{App.domain}/no-image.png"
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }

  validates :description, :start_date, :end_date, presence: true
end
