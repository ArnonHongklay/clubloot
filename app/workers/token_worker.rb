class TokenWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    User.hard_update_token
  end
end
