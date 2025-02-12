json.extract! user, :id, :email_address, :created_at, :updated_at
json.roles user.roles, partial: "roles/role", as: :role
json.profile do
  json.extract! user.profile, :first_name, :last_name if user.profile
end
json.url user_url(user, format: :json)
