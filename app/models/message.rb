class Message
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :postId, type: String
  field :publish_time, type: DateTime
  field :message, type: String

  embedded_in :user
end
