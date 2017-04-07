class DashboardController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :authenticate_user!

  def index
    @richs = User.order(coins: :desc).limit(10)
    @contests = Contest.upcoming
    if params[:all].nil?
      if params[:start].present? and params[:end].present?
        players = User.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))
        contests = Contest.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))

        economy = Economy.where(:logged_at.gte => Time.zone.parse(params[:start]), :logged_at.lte => Time.zone.parse(params[:end]))
        prize = Ledger.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))

        sign_in_range = ApiKey.where(:created_at.gte => Time.zone.parse(params[:start]), :created_at.lte => Time.zone.parse(params[:end]))
        sign_in_all   = sign_in_range.group_by(&:group_by_criteria).map {|k,v| v.length }
        sign_in       = sign_in_all.inject{ |sum, el| sum + el }.to_f / sign_in_all.size
      else
        players = User.where(:created_at.gte => Time.zone.now.beginning_of_day)
        contests = Contest.where(:created_at.gte => Time.zone.now.beginning_of_day)

        economy = Economy.where(:logged_at.gte => Time.zone.now.beginning_of_day)
        prize = Ledger.where(:created_at.gte => Time.zone.now.beginning_of_day)
        sign_in = ApiKey.where(:created_at.gte => Time.zone.now.beginning_of_day).count
      end
    else
      players = User.all
      contests = Contest.all

      economy = Economy.all
      prize = Ledger.all

      sign_in_range = ApiKey.all
      sign_in_all   = sign_in_range.group_by(&:group_by_criteria).map {|k,v| v.length }
      sign_in       = sign_in_all.inject{ |sum, el| sum + el }.to_f / sign_in_all.size
    end
    @total_players = players.count
    @total_contests = contests.count

    loot = economy.where(kind: 'loot').last.try(:value) || 0
    tax = economy.where(kind: 'tax').last.try(:value) || 0

    @total_conomy = number_to_currency(loot, :unit => "", precision: 0)
    @total_tax = number_to_currency(tax, :unit => "", precision: 0)

    @total_prizes = prize.where(format: 'prizes').count

    sign_in_cal = sign_in > 0 ? (sign_in*100) / User.all.count : 0
    @total_signin = number_to_percentage(sign_in_cal, precision: 2)
  end

  def loot
  end
end
