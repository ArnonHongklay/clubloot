class Announcement
  include Mongoid::Document

  field :publish, type: Date
  field :description, type: String
end
