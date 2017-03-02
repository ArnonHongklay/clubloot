class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  belongs_to :program, inverse_of: :templates

  field :name,              type: String
  field :number_questions,  type: Integer
  field :number_answers,    type: Integer

  embeds_many :questions

  field :start_time,        type: DateTime
  field :end_time,          type: DateTime
  field :active,            type: Boolean

  has_many :contests

  after_save :check_choice

  scope :upcoming_program, -> { where(:start_time.gte => Time.zone.now, :end_time.lte => Time.zone.now) }
  scope :live_program, -> { where(:end_time.gte => Time.zone.now) }
  scope :past_program, -> { where(:end_time.gte => Time.zone.now, :end_time.lte => Time.zone.now) }

  def self.upcoming_time
    upcoming = where(:start_time.gte => Time.zone.now, :end_time.lte => Time.zone.now)
    min = nil
    upcoming.each do |m|
      min = m.end_time if min.nil? or min < m.end_time
    end
    min
  end

  private
    def check_choice
      if number_answers_changed? or number_questions_changed?
        self.questions.destroy_all
      end
    end
end
