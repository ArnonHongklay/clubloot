class WinnerWorker
  include Sidekiq::Worker

  def perform(template, contest)
    questions = template.questions

    self.template.contests.each do |contest|
      contest.quizes.where(question_id: self.id).each do |quiz|
        if quiz.answer_id == self.is_correct
          quiz.update(correct: 1)
        else
          quiz.update(correct: 0)
        end
      end
    end
  end
end
