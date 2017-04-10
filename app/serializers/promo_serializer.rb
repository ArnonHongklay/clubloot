class PromoSerializer < ActiveModel::Serializer
  attributes :id, :code, :quantity, :bonus
end
