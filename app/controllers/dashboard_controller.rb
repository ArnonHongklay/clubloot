class DashboardController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :authenticate_user!

  def index
    @richs = User.order(coins: :desc).limit(10)
    @contests = Contest.upcoming

    if params[:start].present? and params[:end].present?
      players = User.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))
      contests = Contest.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))

      conomy = ConomyLog.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))
      prize = Ledger.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))
      tax = Tax.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))

      sign_in_range = SigninLog.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))
      sign_in_all   = sign_in_range.group_by(&:group_by_criteria).map {|k,v| v.length }
      sign_in       = sign_in_all.inject{ |sum, el| sum + el }.to_f / sign_in_all.size
    else
      players = User.all
      contests = Contest.all

      conomy = ConomyLog.all
      prize = Ledger.all
      tax = Tax.all
      sign_in = SigninLog.where(:created_at.gte => Time.zone.now.beginning_of_day).count
    end
    @total_players = players.count
    @total_contests = contests.count

    @total_conomy = number_to_currency(conomy.sum(&:coins) / conomy.count, :unit => "", precision: 0)
    @total_prizes = prize.where('transaction.format' => 'prizes').count
    @total_tax = number_to_currency(tax.sum(&:coin), :unit => "", precision: 0)

    sign_in_cal = sign_in > 0 ? (sign_in*100) / @total_players : 0
    @total_signin = number_to_percentage(sign_in_cal, precision: 2)
  end

  def loot
  end
end
