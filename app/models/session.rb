class Session < ApplicationRecord
  belongs_to :user

  validates :ip_address, presence: true
  validates :user_agent, presence: true
  validates :refresh_token, presence: true

  # def as_json(*)
  #   {
  #     id: id,
  #     user_id: user.id,
  #     signed_in_at: created_at,
  #     revoked: revoked,
  #     refresh_token: session_valid? ? refresh_token : nil,
  #     last_refreshed_at: last_refreshed_at,
  #     refresh_count: refresh_count,
  #     refresh_token_expires_at: session_valid? ? refresh_token_expires_at : nil,
  #     jwt: session_valid? ? "JWT token" : nil,
  #     is_current: Current.session == self,
  #   }
  # end

  def revoke!
    update!(revoked: true)
  end

  def is_valid_session?
    !revoked && refresh_token_expires_at > Time.current
  end

  def refresh!
    update!(last_refreshed_at: Time.current, refresh_count: self.refresh_count + 1)
  end

  private
end
