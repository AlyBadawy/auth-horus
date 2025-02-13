FactoryBot.define do
  factory :session do
    ip_address { "MyString" }
    user_agent { "MyString" }
    refresh_count { 1 }
    refresh_token { "MyString" }
    last_refreshed_at { "2025-02-12 16:33:20" }
    expires_at { "2025-02-12 16:33:20" }
    revoked { false }
    user { nil }
  end
end
