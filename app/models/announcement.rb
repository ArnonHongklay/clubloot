class Announcement
  include Mongoid::Document

  field :publish, type: DateTime
  field :description, type: String
  field :active, type: Boolean, default: true

  has_and_belongs_to_many :users, class_name: 'User', inverse_of: :announcements

  after_create :broadcast_opened
  after_update :edited
  # before_destroy :user_closed

  scope :active, -> { where(active: true) }

  validates :publish, :description, presence: true

  def broadcast_opened
    User.all.each do |user|
      self.users << user
      self.save!

      ActionCable.server.broadcast("announcement_#{user.token}", announcement: user.announcements)
    end
  end

  def edited
    self.users.each do |user|
      ActionCable.server.broadcast("announcement_#{user.token}", announcement: user.announcements)
    end
  end
end
