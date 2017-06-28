class AnswersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :update

  def update
    template = Template.find(params[:template_id])
    question = template.questions.find(params[:question_id])

    respond_to do |format|
      if Time.zone.now > template.end_time
        if question.answers.find(params[:id])
          question.update(is_correct: params[:id])
          format.json { render json: { status: :success, message: 'Completed' }, status: :ok }
        end
      else
        format.json { render json: { status: :error, message: 'You can\'t answer before live time' }, status: :ok }
      end
      # if @answer.update(answer_params)
      #   format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
      #   format.json { render :show, status: :ok, location: @answer }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @answer.errors, status: :unprocessable_entity }
      # end
    end
  end
end
