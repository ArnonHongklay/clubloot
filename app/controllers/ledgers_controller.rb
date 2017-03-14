class LedgersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ledger, only: :show

  def index
    @ledgers = Ledger.order(created_at: :desc)
  end

  def show
  end

  private
    def set_ledger
      @ledger = Ledger.find(params[:id])
    end
end
