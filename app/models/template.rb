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
    contests.where(_state: :live).each do |contest|
      contest.update(state: :end)
      contest.leaders.select{ |ledger| ledger.position == 1 }.each do |player|
        user = User.find(player.id)
        contest.winners << user
        contest.save!
      end

      # if contest.winners.count < contest.max_players

      total_winner = contest.winners.count
      prize        = contest.prize || 0

      if total_winner == 1
        rates = Contest.gem_matrix[:gem][prize]
      elsif total_winner > 1
        rates = Contest.refund_list[total_winner-2][prize]
      end

      contest.winners.each do |user|
        transaction = []

        rates.each do |rate|
          case rate[:type].downcase
          when 'coin'
            user.update(coins: user.coins + rate[:value])
          when 'ruby'
            user.update(rubies: user.rubies + rate[:value])
          when 'sapphire'
            user.update(sapphires: user.sapphires + rate[:value])
          when 'emerald'
            user.update(emeralds: user.emeralds + rate[:value])
          when 'diamond'
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
      # else

      # end
    end
  end

  private
    def check_choice
      if number_answers_changed? or number_questions_changed?
        self.questions.destroy_all
      end
    end
end
