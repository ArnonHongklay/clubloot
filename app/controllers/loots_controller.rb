class LootsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_loot, only: [:index, :update]

  def index
  end

  def update
    respond_to do |format|
      if @loot.update(loot_params)
        format.html { redirect_to loots_path, notice: 'Loot was successfully updated.' }
        format.json { render :show, status: :ok, location: @loot }
      else
        format.html { render :edit }
        format.json { render json: @loot.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loot
      # @loot = Loot.find(params[:id])
      @loot = AppConfigure.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loot_params
      # params.fetch(:loot, {})
      params[:app_configure].permit(:daily_loot, :min_consecutive, :max_consecutive, :more_coin)
    end
end
