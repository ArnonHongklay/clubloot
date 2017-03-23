class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: [:show, :edit, :update, :end_contest, :destroy]
  before_action :set_programs, only: [:new, :edit, :create, :update]

  def index
    @templates = Template.all
    @template_active = @templates.active
    @template_expired = @templates.expired
  end

  def show
  end

  def new
    @template = Template.new
  end

  def edit
  end

  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to new_template_question_path(@template), notice: 'Template was successfully created.' }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @template.update(template_params)
        if @template.questions.count == 0
          format.html { redirect_to new_template_question_path(@template), notice: 'Template was successfully updated.' }
        else
          format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  def end_contest
    @template = Template.last
    @template.update(active: true)
    @template.contests.each do |contest|
      p contest
      Template.end_contest(@template, contest)
    end
    @template.update(active: false)

    respond_to do |format|
      format.json { render :show, status: :ok }
    end
  end

  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: 'Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_template
      @template = Template.find(params[:id])
    end

    def set_programs
      @programs = Program.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      # params.fetch(:template, {})
      params.require(:template).permit(:name, :program, :number_questions, :number_answers, :start_time, :end_time)
    end
end
