class ContestUpcomingWorker
  include Sidekiq::Worker

  def perform(*args)
    current_time = Time.zone.now

    Contest.where(_state: :upcoming).includes(:template).each do |contest|
      start_time  = contest.template.start_time
      end_time    = contest.template.end_time

      if current_time >= start_time
        contest.update(active: true)
      else
        contest.update(active: false)
      end
    end
  end
end
