class Entities::UserAllExpose < Grape::Entity
  expose :email
  expose :first_name
  expose :last_name
  expose :token
  expose :is_admin
end
