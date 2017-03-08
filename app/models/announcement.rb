class Announcement
  include Mongoid::Document

  field :publish, type: Date
  field :description, type: String

  after_create :broadcast

  def broadcast
    # AnnouncementChannel.broadcast_to(
    #   "announcement_#{self.id}",
    #   action: "announcement",
    #   data: self
    # )
    # ActionCable.server.broadcast 'announcement', message: render_message(self)
    ActionCable.server.broadcast("announcement_channel", message: self)
  end

  private
    def render_message(message)
      ApplicationController.renderer.render(partial: 'announcement/message', locals: { message: message })
    end
end
