class AnswersController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token, only: :update

  def update
    question = Template.find(params[:template_id]).questions.find(params[:question_id])
    if question.answers.find(params[:id])
      question.update(is_correct: params[:id])
    end
    # respond_to do |format|
    #   if @answer.update(answer_params)
    #     format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @answer }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @answer.errors, status: :unprocessable_entity }
    #   end
    # end
  end
end
