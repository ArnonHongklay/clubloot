# class WinnerWorker
#   include Sidekiq::Worker

#   def perform(tempalte_id, contest_id)
#     template = Template.find(tempalte_id)
#     contest = Contest.find(contest_id)

#     contest.update(state: :end)
#     contest.leaders.select{ |l| l.position == 1 }.each do |player|
#       user = User.find(player.id)
#       contest.winners << user
#       contest.save!

#       save_transaction(user.id, contest)
#     end
#   end

#   private
#     def save_transaction(user_id, contest)
#       user = User.find(user_id)
#       total_winner = contest.winners.count
#       prize        = contest.prize || 0
#       # prize = fee / total_winner

#       p user.rubies

#       if total_winner == 1
#         rates = Contest.gem_matrix[:gem][prize]
#       elsif total_winner > 1
#         rates = Contest.prize[prize][total_winner]
#       end

#       transaction = []
#       rates.each do |rate|
#         p rate[:type]
#         getFund(user, rate)
#         transaction << OpenStruct.new(
#           status: 'complete',
#           format: 'winners',
#           action: 'plus',
#           description: 'Winner contest',
#           from: 'coins',
#           to: 'winner',
#           unit: rate[:type].downcase,
#           amount: rate[:value],
#           tax: 0
#         )
#       end

#       Ledger.create_transactions(user, transaction)
#     end

#     def getFund(user, rate)
#       if rate[:type].downcase == 'coin'
#         user.update(coins: user.coins + rate[:value])
#       end
#       if rate[:type].downcase == 'ruby'
#         user.update(rubies: user.rubies + rate[:value])
#       end
#       if rate[:type].downcase == 'sapphire'
#         user.update(sapphires: user.sapphires + rate[:value])
#       end
#       if rate[:type].downcase == 'emerald'
#         user.update(emeralds: user.emeralds + rate[:value])
#       end
#       if rate[:type].downcase == 'diamond'
#         user.update(diamonds: user.diamonds + rate[:value])
#       end
#     end
# end
