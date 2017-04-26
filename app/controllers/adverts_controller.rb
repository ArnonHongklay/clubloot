class AdvertsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_advert, only: [:show, :edit, :update, :destroy]

  def giveaways
    if params[:daily].present?
      user = ApiKey.where(:created_at.gte => Time.zone.parse(params[:daily]).beginning_of_day, :created_at.lte => Time.zone.parse(params[:daily]).end_of_day).uniq { |u| u.user_id }
    else
      user = ApiKey.where(:created_at.gte => Time.zone.now.beginning_of_day, :created_at.lte => Time.zone.now.end_of_day).uniq { |u| u.user_id }
    end
    @users = User.find(user.pluck(:user_id))
  end

  def giveaways_checked
    gtime = Time.zone.parse(params[:daily])
    user = ApiKey.where(:created_at.gte => gtime.beginning_of_day, :created_at.lte => gtime.end_of_day).where(user_id: params[:user_id])

    user.update_all(giveaways: !user.first.giveaways)
  end


  # GET /adverts
  # GET /adverts.json
  def index
    @adverts = Advert.order(daily_at: :desc)
  end

  # GET /adverts/1
  # GET /adverts/1.json
  def show
  end

  # GET /adverts/new
  def new
    @advert = Advert.new
  end

  # GET /adverts/1/edit
  def edit
  end

  # POST /adverts
  # POST /adverts.json
  def create
    @advert = Advert.new(advert_params)

    respond_to do |format|
      if @advert.save
        format.html { redirect_to @advert, notice: 'Advert was successfully created.' }
        format.json { render :show, status: :created, location: @advert }
      else
        format.html { render :new }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adverts/1
  # PATCH/PUT /adverts/1.json
  def update
    respond_to do |format|
      if @advert.update(advert_params)
        format.html { redirect_to @advert, notice: 'Advert was successfully updated.' }
        format.json { render :show, status: :ok, location: @advert }
      else
        format.html { render :edit }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    @advert.destroy
    respond_to do |format|
      format.html { redirect_to adverts_url, notice: 'Advert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advert
      @advert = Advert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advert_params
      params.require(:advert).permit(:description, :daily_at, :attachment)
    end
end
