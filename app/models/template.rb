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

  scope :active, -> { where(active: true) }
  scope :expired, -> { where(active: false) }

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

  def end_contest
    return if questions.where('is_correct' => false).count > 0

    update(active: false)
    contests.where(state: :live).each do |contest|
      contest.update(state: :end)
      contest.leaders.select{ |ledger| ledger.position == 1 }.each do |player|
        user = User.find(player.id)
        contest.winners << user
        contest.save!

        total_winner = contest.winners.count
        prize        = contest.prize || 0

        if total_winner == 1
          rates = Contest.gem_matrix[:gem][prize]
        elsif total_winner > 1
          rates = Contest.refund_list[prize][total_winner]
        end

        transaction = []
        rates.each do |rate|
          if rate[:type].downcase == 'coin'
            user.update(coins: user.coins + rate[:value])
          end
          if rate[:type].downcase == 'ruby'
            user.update(rubies: user.rubies + rate[:value])
          end
          if rate[:type].downcase == 'sapphire'
            user.update(sapphires: user.sapphires + rate[:value])
          end
          if rate[:type].downcase == 'emerald'
            user.update(emeralds: user.emeralds + rate[:value])
          end
          if rate[:type].downcase == 'diamond'
            user.update(diamonds: user.diamonds + rate[:value])
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

        Ledger.create_transactions(user, transaction)
      end
    end
  end

  private
    def check_choice
      if number_answers_changed? or number_questions_changed?
        self.questions.destroy_all
      end
    end
end
