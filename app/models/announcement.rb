class Announcement
  include Mongoid::Document

  field :publish, type: Date
  field :description, type: String

  after_touch :broadcast

  private
    def broadcast
      # AnnouncementChannel.broadcast_to(
      #   "announcement_#{self.id}",
      #   action: "announcement",
      #   data: self
      # )
      # ActionCable.server.broadcast 'announcement', message: render_message(self)
      p self
      ActionCable.server.broadcast("announcement_channel", message: render_message(self))
    end

    def render_message(message)
      ApplicationController.renderer.render(partial: 'announcement/message', locals: { message: message })
    end
end
