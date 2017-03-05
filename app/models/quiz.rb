class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps

  field :player_id,   type: String
  field :question_id, type: String
  field :answer_id,   type: String
  field :correct,     type: Integer, default: 0

  embedded_in :contest
  # belongs_to :player, class_name: 'User', inverse_of: :player
  # embeds_many :answers
  # embedded_in :template
end
