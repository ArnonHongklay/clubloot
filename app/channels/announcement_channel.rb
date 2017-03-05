class AnnouncementChannel < ApplicationCable::Channel
  def subscribed
    stream_from "announcement_#{params[:announcement_id]}"
  end

  def receuve(data)
    ActionCable.server.broadcast("announcement_#{params[:announcement_id]}", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
