class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :is_correct,  type: String, default: :false
  field :name,        type: String

  embeds_many :answers
  embedded_in :template

  after_save :broadcast_answer

  private
    def broadcast_answer
      self.template.contests.each do |contest|
        contest.quizes.where(question_id: self.id).each do |quiz|
          if quiz.answer_id == self.is_correct
            quiz.update(correct: 1)
          else
            quiz.update(correct: 0)
          end
        end
      end

      data = { page: 'contest_details', action: 'update' }
      ActionCable.server.broadcast("contest_channel", data)
    end
end
