class Entities::V2::UserAllExpose < Grape::Entity
  expose :id
  expose :email
  expose :username
  expose :first_name
  expose :last_name
  expose :is_admin
  expose :diamonds
  expose :emeralds
  expose :sapphires
  expose :rubies
  expose :coins
  expose :free_loot
  expose :promo_code
  expose :promo_value do |item|
    item.promo.try(:bonus)
  end
  expose :promo_currency do |item|
    item.promo.try(:currency_unit)
  end
  expose :winners do |item|
    item.winners.count
  end
  expose :prizes, with: Entities::V2::PrizeExpose
end
