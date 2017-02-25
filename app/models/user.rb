class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  # has_many :ratings
  # has_and_belongs_to_many :rooms, inverse_of: :users
  # has_many :host_room, class_name: 'Room', inverse_of: :host
  # has_many :ratings_to, class_name: 'Rating', inverse_of: :from_user

  # after_create :initial_leaderboard

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

  # stats
  field :skill,        type: Float, default: 0.0
  field :timeliness,   type: Float, default: 0.0
  field :completion,   type: Float, default: 0.0
  field :language,     type: Float, default: 0.0
  field :friendliness, type: Float, default: 0.0

  # free text descriptions
  field :type_of_game,  type: String
  field :time_to_play,  type: String
  field :gear_used,     type: String
  field :stream,        type: String
  field :chat_time,     type: String

  has_mongoid_attached_file :avatar,
    styles: {
      :medium   => ['250x250',    :jpg]
    },
    default_url: ActionController::Base.helpers.asset_path('user_no_avatar.png')
  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validates_uniqueness_of :username

  # validates :username, :first_name, :last_name, :bio, :dob, :gender, :zip_code, presence: true

  def hosted
    host_room.count
  end

  def played
    rooms.played.count
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email      = auth.info.email
      user.first_name = auth.extra.raw_info.first_name
      user.last_name  = auth.extra.raw_info.last_name
      user.password   = Devise.friendly_token[0,20]
      user.gender     = auth.extra.raw_info.gender
      user.dob        = auth.extra.raw_info.birthday
    end
  end

  def self.initial_by_fb_access_token(access_token)
    graph = Koala::Facebook::API.new(access_token)
    profile = graph.get_object("me", fields: "email, first_name, last_name, gender, birthday")

    where(provider: 'facebook', uid: profile["id"]).first_or_initialize.tap do |user|
      user.email      = profile["email"]
      user.first_name = profile["first_name"]
      user.last_name  = profile["last_name"]
      user.password   = Devise.friendly_token[0,20]
      user.gender     = profile["gender"]
      user.dob        = profile["birthday"]
    end
  end

  def update_stats
    stats = %w{skill timeliness completion language friendliness}
    cumulative = {}
    self.ratings.active.each do |rating|
      stats.each {|stat| cumulative[stat] = cumulative[stat] ? cumulative[stat] + rating[stat] : rating[stat] }
    end

    cumulative.each {|k, v| cumulative[k] = v / ratings.count }
    update!(cumulative)
  end

  def rating
    stats = %w{skill timeliness completion language friendliness}
    (stats.inject(0) {|sum, stat| sum + self[stat].clamp(0, 10) } / stats.length).to_i
  end

  def need_more_information?
    %w{type_of_game time_to_play gear_used stream chat_time}.collect{|x| self[x].blank? }.any?
  end

  def mockup_demo
    # host room
    game = Game.offset(rand(Game.count)).first
    params = {
      name: "#{username}'s room",
      game: game,
      level: "#{rand(0..99)}",
      rewards: "your rewards here",
      description: "#{username}'s first room to introduce systems",
      available_date: DateTime.tomorrow,
      available_time: DateTime.tomorrow.to_time + rand(1..24).hours,
      max_players: rand(2..10),
      state: "waiting",
      host: self
    }
    first_room = Room.create!(params)

    # add some demo acc to join
    if User.count > 2
      random_user = User.where(:id.ne => id).first
      first_room.add_user(random_user)
      # finish room
      first_room.update!(state: "complete")
      first_room.pending_rating
      # and update ratings
      rating_params = {
        skill: 1,
        timeliness: 2,
        completion: 3,
        language:4,
        friendliness: 5
      }
      ratings.first.update!(rating_params)
      ratings.first.update!(active: true)
    end
  end

private

  def initial_leaderboard
    $leaderboard.rank_member(self.id, 0)
    # for demo only
    mockup_demo
  end

  def get_score_from(rating)
    stats = %w{skill timeliness completion language friendliness}
    stats.inject(0) {|sum, stat| sum + rating[stat].clamp(0, 10) } / stats.length
  end

  def add_score(rating)
    $leaderboard.change_score_for(self.id, get_score_from(rating))
  end

  def remove_score(rating)
    $leaderboard.change_score_for(self.id, -get_score_from(rating))
  end
end
