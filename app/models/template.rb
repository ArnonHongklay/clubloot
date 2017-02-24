class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  belongs_to :program, inverse_of: :templates

  field :name,              type: String
  field :program,           type: Integer
  field :number_questions,  type: String
  field :number_answers,    type: String

  embeds_many :questions
  embeds_many :contests

  field :start_time,        type: DateTime
  field :end_time,          type: DateTime
  field :active,            type: Boolean


  after_save :check_choice

  private
    def check_choice
      if number_answers_changed? or number_questions_changed?
        self.questions.destroy_all
      end
    end
end
