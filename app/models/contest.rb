class Contest
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :name,  type: String
  field :max_players, type: Integer, default: 2

  # field :status, type: String
  enum :status, [:usable, :unusable], default: :usable
  field :active, type: Boolean, default: false
  enum :state, [:upcoming, :live, :end, :cancel], default: :upcoming

  field :prize, type: Integer
  field :fee, type: Integer
  field :fee_index, type: Integer
  field :public, type: Boolean, default: true

  belongs_to :template, inverse_of: :contests
  belongs_to :host, class_name: 'User', inverse_of: :host_contests

  has_and_belongs_to_many :players, class_name: 'User', inverse_of: :contests
  has_and_belongs_to_many :winners, class_name: 'User', inverse_of: :winners
  # has_many :players, class_name: 'ContestPlayer', inverse_of: :contest
  # has_many :winners, class_name: 'ContestWinner', inverse_of: :contest

  embeds_many :quizes, class_name: 'Quiz' #, dependent: :nullify

  scope :active,  -> { where(active: true) }
  scope :pending, -> { where(active: false) }

  PLAYER_MIN = 2
  PLAYER_MAX = 20
  FEE_MIN = 0
  FEE_MAX = 10

  after_save :update_tax_collected

  def self.save_transaction(user, contest)
    fee = (contest.fee * 10 / 11)
    tax = contest.fee - fee

    transaction = []
    transaction << OpenStruct.new(
      status: 'complete',
      format: 'contest',
      action: 'minus',
      description: 'create or join contest',
      from: 'coins',
      to: 'contest',
      unit: 'coins',
      amount: fee
      # tax: tax
    )

    transaction << OpenStruct.new(
      status: 'complete',
      format: 'contest',
      action: 'minus',
      description: 'tax',
      from: 'coins',
      to: 'contest',
      unit: 'coins',
      amount: tax
      # tax: tax
    )

    user.update(coins: (user.coins - contest.fee))

    Ledger.create_transactions(user, transaction)
  end

  def self.create_contest(user, template, contest)
    player = contest[:player].to_i
    raise "out of range player" if player < 2 && player > 20
    fee = contest[:fee].to_i
    raise "wrong fee" if fee > 10 && fee < 0

    fee_select = self.gem_matrix[:list].select do |x|
      x[:player] == player
    end.first[:fee][fee]

    raise "Your money is not enough." if user.coins < fee_select

    contest = new( host: user,
                   template: template,
                   name: contest[:name],
                   max_players: contest[:player],
                   fee: fee_select,
                   prize: fee)
    contest.players << user
    if contest.save
      save_transaction(user, contest)
      contest
    else
      false
    end
  end

  def self.join_contest(user, contest_id)
    contest = Contest.find(contest_id)

    raise "joined already" if contest.players.where(id: user.id).present?
    raise "full player" if contest.players.count >= contest.max_players
    raise "live already" if contest._state != :upcoming
    raise "Your money is not enough." if user.coins < contest.fee

    if user.contests.where(id: contest_id).blank?
      contest.players << user
      if contest.save
        save_transaction(user, contest)
        contest
      else
        false
      end
    else
      false
    end
  end

  def self.quiz(user, contest, quizes)
    this_contest = user.contests.find(contest)
    questions = this_contest.template.questions

    if questions.count == quizes.count
      quizes.each do |quiz|
        question = questions.where(id: quiz[:question_id]).first
        if question.present?
          if question.answers.find(quiz[:answer_id]).present?
            this_contest.quizes.create(quiz.merge!(player_id: user.id))
          else
            this_contest.quizes.destroy_all
            raise "this question don't exists"
          end
        else
          raise "this question don't exists"
        end
      end

      ActionCable.server.broadcast("contest_channel", { page: 'dashboard', action: 'update' })
      ActionCable.server.broadcast("contest_channel", { page: 'all_contest', action: 'update' })
      ActionCable.server.broadcast("contest_channel", { page: 'contest_details', action: 'update' })

    else
      this_contest.players.delete(user)
    end
  end

  def self.edit_contest(user, contest_id)
    contest = Contest.find(contest_id)
    if user.contests.where(id: contest_id).present?
      contest
    end
  end

  def self.edit_quiz(user, contest, quizes)
    this_contest = user.contests.find(contest)
    questions = this_contest.template.questions

    # clear old answr
    # this_contest.quizes.destroy_all
    this_contest.quizes.where(player_id: user.id).destroy_all

    quizes.each do |quiz|
      question = questions.where(id: quiz[:question_id]).first
      if question.present?
        if question.answers.find(quiz[:answer_id]).present?
          this_contest.quizes.create(quiz.merge!(player_id: user.id))
        else
          this_contest.quizes.where(player_id: user.id).destroy_all
          raise "this question don't exists"
        end
      else
        raise "this question don't exists"
      end
    end
  end

  def leaders
    leaders = []

    players.each do |player|
      quiz = quizes.where(player_id: player.id)
      leaders.push(
        {
          id: player.id,
          name: player.name,
          username: player.username,
          first_name: player.first_name,
          last_name: player.last_name,
          email: player.email,
          quizes: quiz,
          score: quiz.sum(&:correct),
          position: nil
        }
      )
    end

    leaders_position = leaders.sort!{ |a,b| b[:score] <=> a[:score] }

    temp = []
    leaders_position.each_with_index do |leader, i|
      if i == 0
        leader[:position] = 1
      else
        if leaders_position[i-1][:score] == leaders_position[i][:score]
          leader[:position] = leaders_position[i-1][:position]
        else
          leader[:position] =i + 1
        end
      end
      temp << Hashie::Mash.new(leader)
    end

    temp
  end

  def loot_prize
    prize = self.prize || 0
    if winners.count <= 0
      false
    elsif winners.count == 1
      Contest.gem_matrix[:gem][prize]
    else
      Contest.refund_list[prize][self.winners.count-2]
    end
  end

  def self.prize_list
    [ 110, 220, 330, 440, 550, 1100, 1650, 2200, 2750, 5500, 8250, 11000 ]
  end

  def self.gem_matrix
    {
      list:[
        { player: 2,  fee: [55, 110, 165, 220, 275, 550, 825, 1100, 1375, 2750, 4125, 5500, 6875] },
        { player: 3,  fee: [37, 74, 110, 147, 184, 367, 550, 734, 917, 1834, 2750, 3667, 4584] },
        { player: 4,  fee: [28, 55, 83, 110, 138, 275, 413, 550, 688, 1375, 2063, 2750, 3438] },
        { player: 5,  fee: [22, 44, 66, 88, 110, 220, 330, 440, 550, 1100, 1650, 2200, 2750] },
        { player: 6,  fee: [19, 37, 55, 74, 92, 184, 275, 367, 459, 917, 1375, 1834, 2292] },
        { player: 7,  fee: [16, 32, 48, 63, 79, 158, 236, 315, 393, 786, 1179, 1572, 1965] },
        { player: 8,  fee: [14, 28, 42, 55, 69, 138, 207, 275, 344, 688, 1032, 1375, 1719] },
        { player: 9,  fee: [13, 25, 37, 49, 62, 123, 184, 245, 306, 612, 917, 1223, 1528] },
        { player: 10, fee: [11, 22, 33, 44, 55, 110, 165, 220, 275, 550, 825, 1100, 1375] },
        { player: 11, fee: [10, 20, 30, 40, 50, 100, 150, 200, 250, 500, 750, 1000, 1250] },
        { player: 12, fee: [10, 19, 28, 37, 46, 92, 138, 184, 230, 459, 688, 917, 1146] },
        { player: 13, fee: [9, 17, 26, 34, 43, 85, 127, 170, 212, 424, 635, 847, 1058] },
        { player: 14, fee: [8, 16, 24, 32, 40, 79, 118, 158, 197, 393, 590, 786, 983] },
        { player: 15, fee: [8, 15, 22, 30, 37, 74, 110, 147, 184, 367, 550, 734, 917] },
        { player: 16, fee: [7, 14, 21, 28, 35, 69, 104, 138, 172, 344, 516, 688, 860] },
        { player: 17, fee: [7, 13, 20, 26, 33, 65, 98, 130, 162, 324, 486, 648, 809] },
        { player: 18, fee: [7, 13, 19, 25, 31, 62, 92, 123, 153, 306, 459, 612, 764] },
        { player: 19, fee: [6, 12, 18, 24, 29, 58, 87, 116, 145, 290, 435, 597, 724] },
        { player: 20, fee: [6, 11, 17, 22, 28, 55, 83, 110, 138, 275, 413, 550, 688] }
      ],
      gem: [
        [ { type: 'RUBY', value: 1 } ],
        [ { type: 'RUBY', value: 2 } ],
        [ { type: 'RUBY', value: 3 } ],
        [ { type: 'RUBY', value: 4 } ],

        [ { type: 'SAPPHIRE', value: 1 } ],
        [ { type: 'SAPPHIRE', value: 2 } ],
        [ { type: 'SAPPHIRE', value: 3 } ],
        [ { type: 'SAPPHIRE', value: 4 } ],

        [ { type: 'EMERALD', value: 1 } ],
        [ { type: 'EMERALD', value: 2 } ],
        [ { type: 'EMERALD', value: 3 } ],
        [ { type: 'EMERALD', value: 4 } ],

        [ { type: 'DIAMOND', value: 1 } ]
      ]
    }
  end

  def self.refund_list
    [
      [
        [{type: 'coin', value: 50}],
        [{type: 'coin', value: 34}],
        [{type: 'coin', value: 25}],
        [{type: 'coin', value: 20}],
        [{type: 'coin', value: 17}],
        [{type: 'coin', value: 15}],
        [{type: 'coin', value: 13}],
        [{type: 'coin', value: 12}],
        [{type: 'coin', value: 10}]
      ],
      #1R 67C 50C 40C 34C 29C 25C 23C 20C
      [
        [{type: 'ruby', value: 1}],
        [{type: 'coin', value: 67}],
        [{type: 'coin', value: 50}],
        [{type: 'coin', value: 40}],
        [{type: 'coin', value: 34}],
        [{type: 'coin', value: 29}],
        [{type: 'coin', value: 25}],
        [{type: 'coin', value: 23}],
        [{type: 'coin', value: 20}]
      ],
      #1R 50C 1R  75C 60C 50C 43C 38C 34C 30C
      [
        [{type: 'ruby', value: 1}, {type: 'coin', value: 50}],
        [{type: 'ruby', value: 1}],
        [{type: 'coin', value: 75}],
        [{type: 'coin', value: 60}],
        [{type: 'coin', value: 50}],
        [{type: 'coin', value: 43}],
        [{type: 'coin', value: 38}],
        [{type: 'coin', value: 34}],
        [{type: 'coin', value: 30}]
      ],
      #2R 1R 34C  1R  80C 67C 58C 50C 45C 40C
      [
        [{type: 'ruby', value: 2}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 34}],
        [{type: 'ruby', value: 1}],
        [{type: 'coin', value: 80}],
        [{type: 'coin', value: 67}],
        [{type: 'coin', value: 58}],
        [{type: 'coin', value: 50}],
        [{type: 'coin', value: 45}],
        [{type: 'coin', value: 40}]
      ],
      #2R 50C 1R 67C  1R 25C  1R  84C 72C 63C 56C 50C
      [
        [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 67}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 25}],
        [{type: 'ruby', value: 1}],
        [{type: 'coin', value: 84}],
        [{type: 'coin', value: 72}],
        [{type: 'coin', value: 63}],
        [{type: 'coin', value: 56}],
        [{type: 'coin', value: 50}]
      ],
      #1S 3R 34C  2R 50C  2R  1R 67C  1R 43C  1R 25C  1R 12C  1R
      [
        [{type: 'sapphire', value: 1}],
        [{type: 'ruby', value: 3}, {type: 'coin', value: 34}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'ruby', value: 2}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 67}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 43}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 25}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 12}],
        [{type: 'ruby', value: 1}]
      ],
      #1S 2R 50C  1S  3R 75C  3R  2R 50C  2R 15C  1R 88C  1R 67C  1R 50C
      [
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'sapphire', value: 1}],
        [{type: 'ruby', value: 3}, {type: 'coin', value: 75}],
        [{type: 'ruby', value: 3}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 15}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 88}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 67}],
        [{type: 'ruby', value: 1}, {type: 'coin', value: 50}]
      ],
      #2S 1S 1R 67C 1S  4R  3R 34C  2R 86C  2R 50C  2R 23C  2R
      [
        [{type: 'sapphire', value: 2}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
        [{type: 'sapphire', value: 1}],
        [{type: 'ruby', value: 4}],
        [{type: 'ruby', value: 3}, {type: 'coin', value: 34}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 86}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 23}],
        [{type: 'ruby', value: 2}]
      ],
      #2S 2R 50C  1S 3R 34C 1S 1R 25C 1S  4R 17C  3R 58C  3R 13C  2R 78C  2R 50C
      [
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 1}, {type: 'coin', value: 25}],
        [{type: 'sapphire', value: 1}],
        [{type: 'ruby', value: 4}, {type: 'coin', value: 17}],
        [{type: 'ruby', value: 3}, {type: 'coin', value: 58}],
        [{type: 'ruby', value: 3}, {type: 'coin', value: 13}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 78}],
        [{type: 'ruby', value: 2}, {type: 'coin', value: 50}]
      ],
      # 1E  3S 1R 67C 2S 2R 50C 2S  1S 3R 34C 1S 2R 15C 1S 25C  1S 56C  1S
      [
        [{type: 'emerald', value: 1}],
        [{type: 'sapphire', value: 3}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'sapphire', value: 2}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 2}, {type: 'coin', value: 15}],
        [{type: 'sapphire', value: 1}, {type: 'coin', value: 56}],
        [{type: 'sapphire', value: 1}, {type: 'coin', value: 25}],
        [{type: 'sapphire', value: 1}]
      ],
      # 1E 2S 2R 50C  1E  3S 3R 75C 3S  2S 2R 50C 2S 72C  1S 4R 38C 1S 3R 34C 1S 2R 50C
      [
        [{type: 'emerald', value: 1}, {type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'emerald', value: 1}],
        [{type: 'sapphire', value: 3}, {type: 'ruby', value: 3}, {type: 'coin', value: 75}],
        [{type: 'sapphire', value: 3}],
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'sapphire', value: 2}, {type: 'coin', value: 72}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 4}, {type: 'coin', value: 38}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
        [{type: 'sapphire', value: 1}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}]
      ],
      #2E 1E 1S 3R 34C  1E  4S  3S 1R 67C 2S 4R 29C 2S 2R 50C 2S 1R 12C 2S
      [
        [{type: 'emerald', value: 2}],
        [{type: 'emerald', value: 1}, {type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
        [{type: 'emerald', value: 1}],
        [{type: 'sapphire', value: 4}],
        [{type: 'sapphire', value: 3}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 4}, {type: 'coin', value: 29}],
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 1}, {type: 'coin', value: 12}],
        [{type: 'sapphire', value: 2}]
      ],
      #2E 2S 2R 50C 1E 3S 1R 67C  1E 1S 1R 25C  1E  4S 84C  3S 2R 86C 3S 63C  2S 3R 89C 2S 2R 50C
      [
        [{type: 'emerald', value: 2}, {type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
        [{type: 'emerald', value: 1}, {type: 'sapphire', value: 3}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
        [{type: 'emerald', value: 1}, {type: 'sapphire', value: 1}, {type: 'ruby', value: 1}, {type: 'coin', value: 25}],
        [{type: 'emerald', value: 1}],
        [{type: 'sapphire', value: 4}, {type: 'coin', value: 84}],
        [{type: 'sapphire', value: 3}, {type: 'ruby', value: 2}, {type: 'coin', value: 86}],
        [{type: 'sapphire', value: 3}, {type: 'coin', value: 63}],
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 3}, {type: 'coin', value: 89}],
        [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}]
      ]
    ]
  end

  def self.tax_collected
    economy = 0

    Contest.all.each do |contest|
      economy += contest.fee - (contest.fee * 10 / 11)
    end

    Economy.create(kind: 'tax', value: economy, logged_at: Time.zone.now)
  end

  def self.new_permitted_params(details)
    contest_name      = details[:name]
    contest_player    = details[:player].to_i
    contest_fee_index = details[:fee].to_i

    p contest_name
    p contest_player
    p contest_fee_index

    raise 'Name is wrong'       if contest_name.blank? || Contest.where(name: contest_name).present?
    raise 'Out of player range' if contest_player < PLAYER_MIN && contest_player > PLAYER_MAX
    raise 'Fee is wrong'        if contest_fee_index < FEE_MIN && contest_fee_index > FEE_MAX

    contest_fee = Contest.gem_matrix[:list].select do |matrix|
      matrix[:player] == contest_player
    end.first[:fee][contest_fee_index]

    contest_details           = OpenStruct.new
    contest_details.name      = contest_name
    contest_details.player    = contest_player
    contest_details.fee       = contest_fee
    contest_details.fee_index = contest_fee_index

    contest_details
  rescue
    false
  end

  def self.join_permitted_params(details)
    contest_details           = OpenStruct.new
    contest_details
  rescue
    false
  end

  private
    def update_tax_collected
      # Contest.tax_collected
      User.loot_economy
    end
end
