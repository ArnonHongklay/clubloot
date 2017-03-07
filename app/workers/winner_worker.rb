class WinnerWorker
  include Sidekiq::Worker

  def perform(tempalte_id, contest_id)
    # questions = template.questions

    # self.template.contests.each do |contest|
    #   contest.quizes.where(question_id: self.id).each do |quiz|
    #     if quiz.answer_id == self.is_correct
    #       quiz.update(correct: 1)
    #     else
    #       quiz.update(correct: 0)
    #     end
    #   end
    # end
    template = Template.find(tempalte_id)
    contest = Contest.find(contest_id)

    contest.update(_state: :end)
    contest.leaders.select{ |l| l.position == 1 }.each do |player|
      user = User.find(player.id)
      contest.winners << user
      contest.save!

      save_transaction(user, contest)
    end

  end

  private
    def save_transaction(user, contest)
      total_winner = contest.winners.count
      prize          = contest.prize
      # prize = fee / total_winner

      rate = Contest.refund_list[prize][total_winner]

      transaction = OpenStruct.new(
        status: 'complete',
        format: 'winners',
        action: 'plus',
        description: 'Winner contest',
        from: 'coins',
        to: 'winner',
        unit: 'coins',
        amount: rate[:value],
        tax: 0
      )

      getFund(user, rate)
      Ledger.create_transaction(user, transaction)
    end

    def getFund(user, rate)
      if rate[:type] == 'coin'
        user.update(coins: user.coins + rate[:value])
      end
      if rate[:type] == 'ruby'
        user.update(rubies: user.rubies + rate[:value])
      end
      if rate[:type] == 'sapphire'
        user.update(sapphires: user.sapphires + rate[:value])
      end
      if rate[:type] == 'emerald'
        user.update(emeralds: user.emeralds + rate[:value])
      end
      if rate[:type] == 'diamond'
        user.update(diamonds: user.diamonds + rate[:value])
      end
    end
end
