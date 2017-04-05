class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  # store_in collection: 'accounts'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  ## Database authenticatable
  field :email,                 type: String, default: ""
  field :encrypted_password,    type: String, default: ""
  field :authentication_token,  type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  field :locked_at,       type: Time

  ## User Info
  field :name,            type: String, default: ""
  field :username,        type: String, default: ""
  field :first_name,      type: String, default: ""
  field :last_name,       type: String, default: ""
  field :date_of_birth,   type: Date

  field :billing_address, type: String
  field :billing_city,    type: String
  field :billing_state,   type: String
  field :billing_zipcode, type: String
  field :mailing_address, type: String
  field :mailing_city,    type: String
  field :mailing_state,   type: String
  field :mailing_zipcode, type: String

  field :lifetime_puchases,   type: Integer
  field :lastest_purchase,    type: Date
  field :total_logins,        type: Integer
  field :consecutive_logins,  type: Integer
  field :last_seen,           type: Date
  field :is_admin,            type: Boolean, default: false

  # omminuath
  field :provider,        type: String, default: ""
  field :uid,             type: String, default: ""

  # stats
  field :diamonds,        type: Integer, default: 0
  field :emeralds,        type: Integer, default: 0
  field :sapphires,       type: Integer, default: 0
  field :rubies,          type: Integer, default: 0
  field :coins,           type: Integer, default: 0

  has_mongoid_attached_file :avatar,
    styles: {
      :medium   => ['250x250',    :jpg]
    },
    default_url: ActionController::Base.helpers.asset_path('user_no_avatar.png')
  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validates_uniqueness_of :username

  has_and_belongs_to_many :contests, inverse_of: :players
  # has_many :user_contests
  # has_many :contests, inverse_of: :players, through: :user_contests
  has_many :host_contests, class_name: 'Contest', inverse_of: :host

  has_and_belongs_to_many :winners, class_name: 'Contest', inverse_of: :winners

  # has_and_belongs_to_many :prizes, class_name: 'Prize', inverse_of: :users
  has_many :prizes, class_name: 'UserPrize', inverse_of: :user

  belongs_to :promo, class_name: 'Promo', inverse_of: :users, optional: true

  has_and_belongs_to_many :announcements, class_name: 'Announcement', inverse_of: :users

  embeds_many :messages

  before_save :ensure_authentication_token
  after_save :update_loot_economy
  after_create :payout_promo
  # validates :username, :first_name, :last_name, :bio, :dob, :gender, :zip_code, presence: true

  def payout_promo
    amount = self.promo.try(:amount) || 0
    return true if amount == 0
    self.update(coins: self.coins + amount)
    # ledger
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def self.hard_update_token
    User.all.each do |user|
      user.update(token: App.generate_code(32)) unless user.token.present?
    end
  end

  def get_prizes(prize_id)
    user = self
    prize = Prize.find(prize_id)
    raise "error prize" unless prize.present?
    raise "dimonds less" if user.diamonds < prize.price
    raise "prize is not available" if prize.out_of_stock?

    amount = user.diamonds - prize.price

    transaction = OpenStruct.new(
      status: 'complete',
      format: 'prizes',
      action: 'minus',
      description: 'Prizes',
      from: 'diamonds',
      to: 'prizes',
      unit: 'diamonds',
      amount: amount,
      tax: 0
    )
    Ledger.create_transaction(user, transaction)

    user.update(diamonds: amount)
    user.prizes.create(prize: prize.id)
  end

  def advanced_ledger(params)
    coins_was = self.coins
    diamonds_was = self.diamonds
    emeralds_was = self.emeralds
    sapphires_was = self.sapphires
    rubies_was = self.rubies
    coins_was = self.coins

    update( diamonds: params[:diamonds].to_i,
            emeralds: params[:emeralds].to_i,
            sapphires: params[:sapphires].to_i,
            rubies: params[:rubies].to_i,
            coins: params[:coins].to_i
    )

    coins_changed = true if coins_was != coins
    diamonds_changed = true if diamonds_was != diamonds
    emeralds_changed = true if emeralds_was != emeralds
    sapphires_changed = true if sapphires_was != sapphires
    rubies_changed = true if rubies_was != rubies

    transaction = []
    action = nil

    if coins_changed
      if coins_was < self.coins
        action = 'plus'
      else
        action = 'minus'
      end

      transaction << OpenStruct.new(
        status: 'complete',
        format: 'advanced',
        action: action,
        description: 'Admin advanced',
        from: 'admin',
        to: 'coins',
        unit: 'coins',
        amount: self.coins - coins_was,
        tax: 0
      )
    end

    if diamonds_changed
      if diamonds_was < self.diamonds
        action = 'plus'
      else
        action = 'minus'
      end

      transaction << OpenStruct.new(
        status: 'complete',
        format: 'advanced',
        action: action,
        description: 'Admin advanced',
        from: 'admin',
        to: 'diamonds',
        unit: 'diamonds',
        amount: self.diamonds - diamonds_was,
        tax: 0
      )
    end

    if emeralds_changed
      if emeralds_was < self.emeralds
        action = 'plus'
      else
        action = 'minus'
      end

      transaction << OpenStruct.new(
        status: 'complete',
        format: 'advanced',
        action: action,
        description: 'Admin advanced',
        from: 'admin',
        to: 'emeralds',
        unit: 'emeralds',
        amount: self.emeralds - emeralds_was,
        tax: 0
      )
    end

    if sapphires_changed
      if sapphires_was < self.sapphires
        action = 'plus'
      else
        action = 'minus'
      end

      transaction << OpenStruct.new(
        status: 'complete',
        format: 'advanced',
        action: action,
        description: 'Admin advanced',
        from: 'admin',
        to: 'sapphires',
        unit: 'sapphires',
        amount: self.sapphires - sapphires_was,
        tax: 0
      )
    end

    if rubies_changed
      if rubies_was < self.rubies
        action = 'plus'
      else
        action = 'minus'
      end

      transaction << OpenStruct.new(
        status: 'complete',
        format: 'advanced',
        action: action,
        description: 'Admin advanced',
        from: 'admin',
        to: 'rubies',
        unit: 'rubies',
        amount: self.rubies - rubies_was,
        tax: 0
      )
    end

    if transaction.length > 0
      Ledger.create_transactions(self, transaction)
    end
  end

  def self.loot_economy
    economy = 0

    User.all.each do |u|
      u.update(coins: 0) if u.coins.nil?
      u.update(rubies: 0) if u.rubies.nil?
      u.update(sapphires: 0) if u.sapphires.nil?
      u.update(emeralds: 0) if u.emeralds.nil?
      u.update(diamonds: 0) if u.diamonds.nil?

      c = u.coins
      r = u.rubies * 100
      s = u.sapphires * 500
      e = u.emeralds * 2500
      d = u.diamonds * 12500
      economy += (c + r + s + e + d)
    end

    Economy.create(kind: 'loot', value: economy, logged_at: Time.zone.now)
  end

  private

    def update_loot_economy
      User.loot_economy
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end
