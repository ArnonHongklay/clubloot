class ContestLiveWorker
  include Sidekiq::Worker

  def perform(*args)
    current_time = Time.zone.now

    Contest.where(state: :upcoming).includes(:template).each do |contest|
      start_time  = contest.template.start_time
      end_time    = contest.template.end_time

      if current_time >= end_time
        if contest.players.count < contest.max_players
          contest.update(state: :cancel, active: false, _status: :unusable)
        else
          contest.update(state: :live, active: false)
        end
        contest.template.update(active: false) if contest.template.active
      end
    end
  end
end
