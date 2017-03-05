class Announcement
  include Mongoid::Document

  field :publish, type: Date
  field :description, type: String

  # after_create :push_socket
  after_touch do
    # CommentRelayJob.perform_later(self)
    self.broadcast
  end

  def broadcast
    # ActionCable.server.broadcast(
    #   "announcement_#{self.id}",
    #   publish: self.publish,
    #   description: self.description
    # )

    AnnouncementChannel.broadcast_to(
      "announcement_#{self.id}",
      action: "announcement",
      data: self
    )
  end
end
