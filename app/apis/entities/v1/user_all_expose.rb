class Entities::V1::UserAllExpose < Grape::Entity
  expose :email
  expose :username
  expose :first_name
  expose :last_name
  expose :token
  expose :is_admin
  expose :diamonds
  expose :emeralds
  expose :sapphires
  expose :rubies
  expose :coins
  expose :prizes
  expose :winners do |item|
    item.winners.count
  end
end
