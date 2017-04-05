class Promo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code,        type: String
  field :quantity,    type: Integer
  field :bonus,       type: Integer
  field :expires_at,  type: DateTime

  # scope :active, -> { where(active: true) }
end
