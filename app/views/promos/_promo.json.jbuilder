json.extract! promo, :id, :code, :quantity, :bonus, :created_at, :updated_at
json.url promo_url(promo, format: :json)
