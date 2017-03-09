class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @richs = User.order(coins: :desc).limit(10)
    @contests = Contest.upcoming

    @total_players = User.count
    @total_contests = Contest.count
    @total_tax = Tax.count
    @total_prizes = Ledger.where('transaction.format' => 'prizes').count
    @total_conomy = ConomyLog.count
    @total_signin = SigninLog.count
  end

  def loot
  end
end
