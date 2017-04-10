class Program
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  has_many :templates

  field :name,      type: String
  field :category,  type: String
  field :active,    type: Boolean, default: false

  has_mongoid_attached_file :attachment
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }

  scope :active,    -> { where(active: true) }
  scope :pending,   -> { where(active: false) }

  validates :name, :category, :attachment, presence: true

  def self.upcoming
    self.active.includes(:templates).select do |program|
      program.templates.upcoming_program.present?
    end
  end

  def self.live
    self.active.includes(:templates).select do |program|
      program.templates.live_program.present?
    end
  end

  def self.past
    self.active.includes(:templates).select do |program|
      program.templates.past_program.present?
    end
  end

  def upcoming_time
    # templates.upcoming_time
    ts = templates.active.where(:start_time.lte => Time.zone.now, :end_time.gte => Time.zone.now)

    min = nil
    ts.each do |template|
      min = template.end_time if min.nil? or template.end_time < min
      # p template.end_time
    end
    min
  end

  def contests
    templates.current_template.contests
  end

  def all_contests
    templates.sort_by(&:end_time).select { |template| template.contests }
  end
end
