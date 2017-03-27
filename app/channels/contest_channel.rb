class ContestChannel < ApplicationCable::Channel
  def subscribed
    stream_from "contest_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast("contest_channel", message: data)
  end
end
