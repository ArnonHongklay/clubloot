class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @richs = User.order(coins: :desc).limit(10)
    @contests = Contest.upcoming
  end

  def loot
  end
end
