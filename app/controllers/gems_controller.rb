class GemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gem, only: [:index, :update]

  def index; end

  def update
    respond_to do |format|
    #   if @gem.update(gem_params)
    #     format.html { redirect_to @gem, notice: 'Gem was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @gem }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @gem.errors, status: :unprocessable_entity }
    #   end

      @gem.set('ruby.rate' => gem_params[:ruby_rate],          'ruby.fee' => gem_params[:ruby_fee])
      @gem.set('sapphire.rate' => gem_params[:sapphire_rate],  'sapphire.fee' => gem_params[:sapphire_fee])
      @gem.set('emerald.rate' => gem_params[:emerald_rate],    'emerald.fee' => gem_params[:emerald_fee])
      @gem.set('diamond.rate' => gem_params[:diamond_rate],    'diamond.fee' => gem_params[:diamond_fee])

      if @gem.reload
        format.html { redirect_to gems_path, notice: 'Gem was successfully updated.' }
        format.json { render :show, status: :ok, location: @gem }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gem
      @gem = AppConfigure.first #.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gem_params
      # params.fetch(:gem, {})
      params[:app_configure].permit(
        :ruby_rate, :ruby_fee,
        :sapphire_rate, :sapphire_fee,
        :emerald_rate, :emerald_fee,
        :diamond_rate, :diamond_fee
      )
    end
end
