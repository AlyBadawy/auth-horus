json.extract! session, :id, :ip_address, :user_agent, :refresh_count, :refresh_token, :last_refreshed_at, :refresh_token_expires_at, :revoked, :user_id, :created_at, :updated_at
json.url my_session_url(session, format: :json)
