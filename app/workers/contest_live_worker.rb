class ContestLiveWorker
  include Sidekiq::Worker

  def perform(*args)
    current_time = Time.zone.now

    Contest.where(_state: :upcoming).includes(:template).each do |contest|
      start_time  = contest.template.start_time
      end_time    = contest.template.end_time

      if current_time >= end_time
        if contest.players.count < contest.max_players
          contest.update(_state: :cancel, active: false, _status: :unusable)

          contest.players.each do |player|
            player.update(coins: player.coins + contest.fee)

            transaction = OpenStruct.new(
              status: 'complete',
              format: 'refund',
              action: 'plus',
              description: 'Refund contest',
              from: 'gem',
              to: 'coins',
              unit: 'coins',
              amount: contest.fee,
              tax: 0
            )

            player.update(coins: player.coins + contest.fee)
            Ledger.create_transaction(player, transaction)
          end
        else
          contest.update(_state: :live, active: false)
        end
        # contest.template.update(active: false) if contest.template.active
      end
    end
  end
end
