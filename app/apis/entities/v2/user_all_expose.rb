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
  expose :winners do |item|
    item.winners.count
  end
end
