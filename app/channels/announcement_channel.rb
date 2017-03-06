class AnnouncementChannel < ApplicationCable::Channel
  def subscribed
    stream_from "announcement_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # ActionCable.server.broadcast("announcement_#{params[:announcement_id]}", message: data['message'])
    Announcement.create! content: data['message']
  end
end
