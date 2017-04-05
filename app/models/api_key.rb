class ApiKey
  include Mongoid::Document
  field :access_token, type: String
  field :expires_at, type: Time
  field :user_id, type: Integer
  field :active, type: Mongoid::Boolean

  # attr_accessible :access_token, :expires_at, :user_id, :active, :application
  before_create :generate_access_token
  before_create :set_expiration
  belongs_to :user

  def expired?
    Time.zone.now >= self.expires_at
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
end
