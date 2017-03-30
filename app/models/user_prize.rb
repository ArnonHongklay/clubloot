class UserPrize
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :tracking_code, type: String
  field :carrier, type: String
  field :status, type: String

  field :state, type: Integer, default: 0

  field :shipped_at, type: DateTime

  belongs_to :user #, class: 'User' #, inverse_of: :prizes
  belongs_to :prize #, class: 'Prize' #, inverse_of: :users

  def update_complete(tracking_code, carrier)
    self.tracking_code = tracking_code
    self.carrier = carrier
    self.state = 1
    self.shipped_at = Time.zone.now
    self.save!
  end
end
