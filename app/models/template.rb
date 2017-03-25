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

  def winners(contest_id)
    contest = Contest.find(contest_id)
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
  end

  def end_contest
    return false if self.active == false or self.questions.where('is_correct' => false).count > 0

    contests.each do |contest|
      player = contest.quizes.all.group_by(&:player_id).map do |key, val|
        { id: key, score: val.sum(&:correct) }
      end
      position = player.sort!{ |a, b| b[:score] <=> a[:score] }
      position.each_with_index do |winner, i|
        break if i != 0 && position[i-1][:score] > position[i][:score]
        contest.winners << User.find(winner[:id])
        contest.save!
      end
      p "=================================== winners ==================================="
      winners(contest.id)
      contest.update(state: :end)
    end
    self.update(active: false)
  end

  private
    def check_choice
      if number_answers_changed? or number_questions_changed?
        self.questions.destroy_all
      end
    end
end
