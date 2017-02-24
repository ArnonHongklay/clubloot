class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_template, only: [:new, :create, :edit, :edit_all, :update, :update_all]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @questions = []
    (0..@template.number_questions.to_i - 1).each do |question|
      @questions[question] = Question.new
      (0..@template.number_answers.to_i - 1).each do |answer|
        @questions[question].answers[answer] = Answer.new
      end
    end
  end

  # GET /questions/1/edit
  def edit
  end

  def edit_all
    @questions = @template.questions
  end

  def update_all
    question_params = params[:q]
    answer_params = params[:a]

    @template.questions.each_with_index do |question, question_index|
      if question.name != question_params[question_index.to_s]
        question.update(name: question_params[question_index.to_s])
      end

      question.answers.each_with_index do |answer, answer_index|
        if answer.name != answer_params[question_index.to_s][answer_index.to_s]
          answer.update(name: answer_params[question_index.to_s][answer_index.to_s])
        end
      end
    end


    # respond_to do |format|
    #   format.html { redirect_to @template, notice: 'Question was successfully created.' }
    #   format.json { render :show, status: :created, location: @question }
    # end
  end

  # POST /questions
  # POST /questions.json
  def create
    questions = params[:q]
    answers = params[:a]
    questions.each do |question|
      temp = @template.questions.create(name: questions[question])
      answers[question].each do |answer|
        temp.answers.create(name: answers[question][answer])
      end
    end

    # @question = Question.new(question_params)

    respond_to do |format|
      # if @question.save
        format.html { redirect_to @template, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @question.errors, status: :unprocessable_entity }
    #   end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    def set_template
      @template = Template.find(params[:template_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      # params.fetch(:question, {})
    end
end
