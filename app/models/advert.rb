class Advert
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :description, type: String
  field :above_description, type: String
  field :below_description, type: String
  field :daily_at, type: DateTime
  # index({ daily_at: 1 }, { unique: true })

  field :start_date, type: DateTime
  field :end_date, type: DateTime

  has_mongoid_attached_file :attachment, :default_url => "#{App.domain}/no-image.png"
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }

  validates :above_description, :below_description, :daily_at, :check_date, presence: true

  private
    def check_date
      if self.daily_at_changed? && self.class.where(:daily_at.gte => self.daily_at.beginning_of_day, :daily_at.lte => self.daily_at.end_of_day).count > 0
        errors.add(:daily_at, "duplicate date")
      else
        true
      end
    end
end
