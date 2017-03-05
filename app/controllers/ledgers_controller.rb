class LedgersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ledger, only: :show

  def index
    @ledgers = Ledger.all
  end

  def show
  end

  private
    def set_ledger
      @ledger = Ledger.find(params[:id])
    end
end
