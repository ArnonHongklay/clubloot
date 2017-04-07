class ApiKey
  include Mongoid::Document
  field :access_token, type: String
  field :expires_at, type: Time
  # field :user_id, type: String
  field :active, type: Mongoid::Boolean

  # attr_accessible :access_token, :expires_at, :user_id, :active, :application
  belongs_to :user

  before_create :generate_access_token
  before_create :set_expiration
  after_create :daily_loot

  def expired?
    Time.zone.now >= self.expires_at
  end

  def group_by_criteria
    created_at.to_date.to_s(:db)
  end

  private
    def generate_access_token
      begin
        self.access_token = Devise.friendly_token
      end while self.class.where(access_token: access_token).exists?
    end

    def set_expiration
      self.expires_at = Time.zone.now + 30
    end

    def daily_loot
      amount = 2000
      if ApiKey.where(:created_at.gte => Time.zone.now.beginning_of_day).count <= 0
        self.user.update(coins: self.user.coins + amount)

        transaction = OpenStruct.new(
          status: 'complete',
          format: 'daily loot',
          action: 'plus',
          description: 'loot',
          from: 'promo',
          to: 'coins',
          unit: 'coins',
          amount: amount,
          tax: 0
        )

        Ledger.create_transaction(self.user, transaction)
      end
    end
end
