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

  def prize(winner, prize)
    p "=================================== in prize ==================================="
    # p winner
    # p prize

    if winner == 1
      Contest.gem_matrix[:gem][prize]
    elsif winner > 1
      Contest.refund_list[prize][winner-2]
    end
  end

  def winners(contest, rates)
    p "=================================== in winners contest ==================================="
    p contest.inspect
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
  end

  def end_contest
    return false if self.active == false or questions.where('is_correct' => false).count > 0
    #
    # else
    #   update(active: false)

    contests.each do |contest|
      contest.update(state: :end)
      winners = contest.leaders.select{ |ledger| ledger.position == 1 }
      winners.each do |player|
        contest.winners << User.find(player.id)
        contest.save!
      end

      p "=================================== winners ==================================="
      # p contest.winners.inspect
      p winners.count

      total_winner  = winners.count
      contest_prize = contest.prize || 0
      rates = prize(total_winner, contest_prize)

      p "=================================== rates ==================================="
      p rates.inspect

      winners(contest, rates)
    end
    # end
  end

  private
    def check_choice
      if number_answers_changed? or number_questions_changed?
        self.questions.destroy_all
      end
    end
end
