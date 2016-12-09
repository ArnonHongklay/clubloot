class Template
  include Mongoid::Document
  # srore_in collection: 'templates', database: 'clubloot-dev'

  field :name, type: String
  field :program, type: String
  field :number_questions, type: String
  field :number_answers, type: String
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :active, type: Boolean
end