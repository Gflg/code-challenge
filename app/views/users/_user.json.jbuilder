json.extract! user, :id, :email, :token, :is_active, :created_at, :updated_at
json.url user_url(user, format: :json)
