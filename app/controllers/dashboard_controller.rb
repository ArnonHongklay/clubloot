class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @richs = User.order(coins: :desc).limit(10)
    @contests = Contest.upcoming

    if params[:start].present? and params[:end].present?
      @total_players = User.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end])).count
      @total_contests = Contest.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end])).count
      @total_tax = Tax.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end])).count
      @total_prizes = Ledger.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end])).where('transaction.format' => 'prizes').count
      @total_conomy = ConomyLog.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end])).count
      @total_signin = SigninLog.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end])).count
    else
      @total_players = User.count
      @total_contests = Contest.count
      @total_tax = Tax.count
      @total_prizes = Ledger.where('transaction.format' => 'prizes').count
      @total_conomy = ConomyLog.count
      @total_signin = SigninLog.count
    end
  end

  def loot
  end
end
