json.extract! profile, :id, :first_name, :last_name, :username, :phone
json.email_address profile.user.email_address
json.url profile_url(profile, format: :json)
