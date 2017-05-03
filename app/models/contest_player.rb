class ContestPlayer
  include Mongoid::Document
  include Mongoid::Timestamps

  # belongs_to :player,   class_name: 'User', polymorphic: true #, inverse_of: :contests
  # belongs_to :contest,  class_name: 'Contest', polymorphic: true #, inverse_of: :players
end
