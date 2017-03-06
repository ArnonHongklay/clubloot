class Announcement
  include Mongoid::Document

  field :publish, type: Date
  field :description, type: String

  after_touch do
    self.broadcast
  end

  def broadcast
    AnnouncementChannel.broadcast_to(
      "announcement_#{self.id}",
      action: "announcement",
      data: self
    )
  end
end
