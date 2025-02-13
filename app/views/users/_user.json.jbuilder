json.extract! user, :id, :email_address, :created_at, :updated_at
json.roles user.roles, partial: "roles/role", as: :role
json.url user_url(user, format: :json)
