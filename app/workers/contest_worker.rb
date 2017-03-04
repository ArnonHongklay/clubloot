class ContestWorker
  include Sidekiq::Worker

  def perform(*args)
    Contest.all.each do |c|
      p c.status
    end
  end
end
