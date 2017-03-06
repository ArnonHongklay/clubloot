class ContestWorker
  include Sidekiq::Worker

  def perform(*args)
    current_time = Time.zone.now

    Contest.includes(:template).each do |contest|
      start_time  = contest.template.start_time
      end_time    = contest.template.end_time

      # if current_time >= start_time
      #   contest.update(active: true)
      # else
      #   contest.update(active: false)
      # end

      # if current_time >= end_time
      #   if contest.players.count < contest.max_players
      #     contest.update(_state: :cancel)
      #   else
      #     contest.update(_state: :live)
      #   end
      # end
    end
  end
end
