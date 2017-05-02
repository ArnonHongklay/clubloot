class ContestPlayer
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :contest
end
