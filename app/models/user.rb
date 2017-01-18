class User
  include Mongoid::Document
  include Mongoid::Paperclip

  after_create :add_to_leaderboard

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  ## Database authenticatable
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## User Info
  field :username, type: String, default: ""
  field :first_name, type: String, default: ""
  field :last_name, type: String, default: ""
  field :bio, type: String, default: ""
  field :dob, type: Date
  field :gender, type: Symbol
  field :zip_code, type: String

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  # omminuath
  field :provider, type: String, default: ""
  field :uid, type: String, default: ""

  has_mongoid_attached_file :avatar,
    :styles => {
      :medium   => ['250x250',    :jpg]
    }

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validates_uniqueness_of :username

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

private
  def add_to_leaderboard
    $leaderboard.rank_member(self.username, 0)
  end
end
