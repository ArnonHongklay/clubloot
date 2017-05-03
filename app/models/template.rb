class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  belongs_to :program, inverse_of: :templates

  field :name,              type: String
  field :number_questions,  type: Integer
  field :number_answers,    type: Integer

  embeds_many :questions

  field :start_time,        type: DateTime
  field :end_time,          type: DateTime
  field :active,            type: Boolean, default: true

  has_many :contests

  after_save :check_choice
  after_create :perform_at

  scope :active, -> { where(active: true) }
  scope :expired, -> { where(active: false) }

  scope :show, -> { active.where(:questions.ne => nil).where(:'questions.answers'.ne => nil) }

  scope :upcoming_program, -> { active.where(:start_time.lte => Time.zone.now, :end_time.gte => Time.zone.now) }
  scope :live_program, -> { active.where(:end_time.lte => Time.zone.now) }
  scope :past_program, -> { expired }

  def self.upcoming_time
    upcoming = self.upcoming_program
    min = nil
    upcoming.each do |m|
      min = m.end_time if min.nil? or min < m.end_time
    end
    min
  end

  def self.current_template
    self.upcoming_program.sort_by(&:end_time).first
  end

  def winners(template_obj)
    template = Template.find(template_obj)
    template.contests.each do |contest|
      # sleep 5
      # contest = Contest.find(contest_id)
      p "=================================== in winners contest ==================================="
      p contest.inspect
      p contest.winners.count

      total_winner  = contest.winners.count
      contest_prize = contest.prize || 0

      rates = if total_winner == 1
        Contest.gem_matrix[:gem][contest_prize]
      elsif total_winner > 1
        Contest.refund_list[contest_prize][total_winner-2]
      end

      p "=================================== rates ==================================="
      p rates.inspect

      contest.winners.each do |user|
        transaction = []
        p "=================================== in winners rate ==================================="
        p rates.inspect

        rates.each do |rate|
          case rate[:type].downcase
          when 'coin'
            user.update(coins: user.coins + rate[:value])
            p "coins #{user.coins}"
          when 'ruby'
            user.update(rubies: user.rubies + rate[:value])
            p "rubies #{user.rubies}"
          when 'sapphire'
            user.update(sapphires: user.sapphires + rate[:value])
            p "sapphires #{user.sapphires}"
          when 'emerald'
            user.update(emeralds: user.emeralds + rate[:value])
            p "emeralds #{user.emeralds}"
          when 'diamond'
            user.update(diamonds: user.diamonds + rate[:value])
            p "diamonds #{user.diamonds}"
          end

          transaction << OpenStruct.new(
            status: 'complete',
            format: 'winners',
            action: 'plus',
            description: 'Winner contest',
            from: 'coins',
            to: 'winner',
            unit: rate[:type].downcase,
            amount: rate[:value],
            tax: 0
          )
        end

        p "=================================== after rate ==================================="
        Ledger.create_transactions(user, transaction)
      end

      contest.update(state: :end)
    end
  end


  def end_contest
    template = self
    return false if template.active == false or template.questions.where('is_correct' => "false").count > 0

    template.contests.where(_state: :upcoming).each do |contest|
      player = contest.quizes.all.group_by(&:player_id).map do |key, val|
        { id: key, score: val.sum(&:correct) }
      end
      position = player.sort!{ |a, b| b[:score] <=> a[:score] }
      position.each_with_index do |winner, i|
        break if i != 0 && position[i-1][:score] > position[i][:score]
        # contest.winners.create!(user: User.find(winner[:id]))
        contest.winners << User.find(winner[:id])
      end
      contest.save!
    end

    winners(template)

    ActionCable.server.broadcast("contest_channel", { page: 'dashboard', action: 'update' })
    ActionCable.server.broadcast("contest_channel", { page: 'all_contest', action: 'update' })
    ActionCable.server.broadcast("contest_channel", { page: 'contest_details', action: 'update' })

    template.update(active: false)
  end

  # Just for testing
  # name = 8.times.map { [*'0'..'9', *'a'..'z'].sample }.join
  # details = { name: name, player: 2, fee: 3 }
  # user = User.first

  # Template.first.new_contest(user, details)
  def new_contest(user, details, quizes)
    contest_details = Contest.new_permitted_params(details)

    raise "Data is wrong"             unless contest_details.present?
    raise "Your money is not enough." if user.coins < contest_details.fee

    unless questions.count == quizes.count
      raise "You still don't answer the question."
    end

    contest = self.contests.create!(
      host:         user,
      name:         contest_details.name,
      max_players:  contest_details.player,
      fee:          contest_details.fee,
      prize:        contest_details.fee_index
    )

    # contest.players.create!(player: user)
    contest.players << user
    if contest.save!
      quizes.each do |quiz|
        question = questions.where(id: quiz[:question_id]).first
        raise "This question don't exists" unless question.present?

        if question.answers.find(quiz[:answer_id]).present?
          contest.quizes.create(quiz.merge!(player_id: user.id))
        else
          raise "This question don't exists"
        end
      end

      p contest
      Contest.save_transaction(user, contest)

      ActionCable.server.broadcast("contest_channel", { page: 'dashboard', action: 'update' })
      ActionCable.server.broadcast("contest_channel", { page: 'all_contest', action: 'update' })
      ActionCable.server.broadcast("contest_channel", { page: 'contest_details', action: 'update' })
    end
  rescue Exception => e
    contest.destroy if contest.present?
    raise e
  end

  private
    def check_choice
      if number_answers_changed? or number_questions_changed?
        self.questions.destroy_all
      end
    end

    def perform_at
      ContestLiveWorker.perform_at(self.end_time + 3.seconds)
    end
end
