class PrizesController < ApplicationController
  before_action :set_prize, only: [:show, :edit, :update, :destroy]

  # GET /prizes
  # GET /prizes.json
  def index
    @prizes = Prize.all
  end

  # GET /prizes/1
  # GET /prizes/1.json
  def show
  end

  # GET /prizes/new
  def new
    @prize = Prize.new
  end

  # GET /prizes/1/edit
  def edit
  end

  # POST /prizes
  # POST /prizes.json
  def create
    @prize = Prize.new(prize_params)

    respond_to do |format|
      if @prize.save
        format.html { redirect_to @prize, notice: 'Prize was successfully created.' }
        format.json { render :show, status: :created, location: @prize }
      else
        format.html { render :new }
        format.json { render json: @prize.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prizes/1
  # PATCH/PUT /prizes/1.json
  def update
    respond_to do |format|
      if @prize.update(prize_params)
        format.html { redirect_to @prize, notice: 'Prize was successfully updated.' }
        format.json { render :show, status: :ok, location: @prize }
      else
        format.html { render :edit }
        format.json { render json: @prize.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prizes/1
  # DELETE /prizes/1.json
  def destroy
    @prize.destroy
    respond_to do |format|
      format.html { redirect_to prizes_url, notice: 'Prize was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prize
      @prize = Prize.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prize_params
      # params.fetch(:prize, {})
      params.require(:prize).permit(:name, :price, :quantity, :description, :attachment)
    end
end
