class Promo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code,          type: String
  field :quantity,      type: Integer
  field :bonus,         type: Integer
  field :currency_unit, type: String
  field :expires_at,    type: DateTime

  has_many :users, class_name: 'User', inverse_of: :promo
  # scope :active, -> { where(active: true) }

  def amount
    case currency_unit
    when 'diamonds'
      bonus * 12500
    when 'emeralds'
      bonus * 2500
    when 'sapphires'
      bonus * 500
    when 'rubies'
      bonus * 100
    when 'coins'
      bonus
    end
  end

  def used
    users.count
  end

  def available
    quantity - users.count
  end

  def self.available?(code)
    promo = find_by(code: code)
    if promo
      promo.users.count < promo.quantity
    else
      false
    end
  end
end
