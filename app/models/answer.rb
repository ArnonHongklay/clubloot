class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :name, type: String

  has_mongoid_attached_file :attachment, :default_url => "/no-image.png"
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }

  embedded_in :question
end
