class AnnouncementChannel < ApplicationCable::Channel
  def subscribed
    stream_from "announcement_#{params[:token]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def show(data)
    if user = User.find_by(token: data['token'])
      ActionCable.server.broadcast("announcement_#{params[:token]}", user.announcements )
    end
  end

  def destroy(data)
    announcement = Announcement.find(data['announcement'])
    user = User.find_by(token: data['token'])

    if user.announcements.delete(announcement)
      ActionCable.server.broadcast("announcement_#{params[:token]}", user.announcements )
    end
  end
end
