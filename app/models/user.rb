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
  field :email,               type: String, default: ""
  field :encrypted_password,  type: String, default: ""
  field :token,               type: String, default: ""

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
  field :birthday,        type: Date

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

  has_and_belongs_to_many :winners, class_name: 'Contest', inverse_of: :winners

  has_many :host_contests, class_name: 'Contest', inverse_of: :host

  # after_save :change_access_token
  # validates :username, :first_name, :last_name, :bio, :dob, :gender, :zip_code, presence: true

  def self.hard_update_token
    User.all.each do |user|
      user.update(token: App.generate_code(32)) unless user.token.present?
    end
  end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  #     user.email      = auth.info.email
  #     user.first_name = auth.extra.raw_info.first_name
  #     user.last_name  = auth.extra.raw_info.last_name
  #     user.password   = Devise.friendly_token[0,20]
  #     user.gender     = auth.extra.raw_info.gender
  #     user.dob        = auth.extra.raw_info.birthday
  #   end
  # end

  # def self.initial_by_fb_access_token(access_token)
  #   graph = Koala::Facebook::API.new(access_token)
  #   profile = graph.get_object("me", fields: "email, first_name, last_name, gender, birthday")

  #   where(provider: 'facebook', uid: profile["id"]).first_or_initialize.tap do |user|
  #     user.email      = profile["email"]
  #     user.first_name = profile["first_name"]
  #     user.last_name  = profile["last_name"]
  #     user.password   = Devise.friendly_token[0,20]
  #     user.gender     = profile["gender"]
  #     user.dob        = profile["birthday"]
  #   end
  # end

  # def update_stats
  #   stats = %w{skill timeliness completion language friendliness}
  #   cumulative = {}
  #   self.ratings.active.each do |rating|
  #     stats.each {|stat| cumulative[stat] = cumulative[stat] ? cumulative[stat] + rating[stat] : rating[stat] }
  #   end

  #   cumulative.each {|k, v| cumulative[k] = v / ratings.count }
  #   update!(cumulative)
  # end

  # private
  #   def change_access_token
  #     loop do
  #       code = App.generate_code(32)
  #       break code unless User.find_by(token: code).present?
  #     end
  #   end

  # def get_score_from(rating)
  #   stats = %w{skill timeliness completion language friendliness}
  #   stats.inject(0) {|sum, stat| sum + rating[stat].clamp(0, 10) } / stats.length
  # end

  # def add_score(rating)
  #   $leaderboard.change_score_for(self.id, get_score_from(rating))
  # end

  # def remove_score(rating)
  #   $leaderboard.change_score_for(self.id, -get_score_from(rating))
  # end
end
