class WinnerWorker
  include Sidekiq::Worker

  def perform(tempalte_id, contest_id)
    # questions = template.questions

    # self.template.contests.each do |contest|
    #   contest.quizes.where(question_id: self.id).each do |quiz|
    #     if quiz.answer_id == self.is_correct
    #       quiz.update(correct: 1)
    #     else
    #       quiz.update(correct: 0)
    #     end
    #   end
    # end
    template = Template.find(tempalte_id)
    contest = Contest.find(contest_id)

    contest.update(state: :end)
    contest.leaders.select{ |l| l.position == 1 }.each do |player|
      contest.winners << User.find(player.id)
      contest.save!
    end
  end
end
