json.extract! user, :id, :created_at, :updated_at
json.roles user.roles, partial: "roles/role", as: :role
json.profile user.profile, partial: "profiles/profile", as: :profile if user.profile
json.url user_url(user, format: :json)
