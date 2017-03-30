class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: [:new, :create, :edit_all, :update_all]

  def new
    @questions = []
    (0..@template.number_questions.to_i - 1).each do |question|
      @questions[question] = Question.new
      (0..@template.number_answers.to_i - 1).each do |answer|
        @questions[question].answers[answer] = Answer.new
      end
    end
  end

  def create
    questions = params[:q]
    answers = params[:a]
    questions.each do |question|
      temp = @template.questions.create(name: questions[question])
      answers[question].each do |answer|
        attach = params[:question]["f"]["#{question}"]["#{answer}"]
        temp.answers.create(name: answers[question][answer], attachment: attach)
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

  private
    def set_template
      @template = Template.find(params[:template_id])
    end
end
