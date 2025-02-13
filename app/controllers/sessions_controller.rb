class SessionsController < ApplicationController
  skip_authentication! only: %i[sign_in refresh]
  before_action :set_session, only: %i[show]

  def index
    @sessions = Current.user&.sessions || []
  end

  def show
  end

  def sign_in
    params.require([:email_address, :password])
    if user = User.authenticate_by(params.permit([:email_address, :password]))
      start_new_session_for user
      render status: :created,
             json: {
               access_token: create_jwt_for_current_session,
               refresh_token: Current.session.refresh_token,
               refresh_token_expires_at: Current.session.refresh_token_expires_at,
             }
    else
      render status: :unauthorized,
             json: {
               error: "Invalid email address or password.",
               fix: "Make sure to send the correct 'email_address' and 'password' in the payload",
             }
    end
  end

  def refresh
    if Current.session = Session.find_by(refresh_token: params[:refresh_token])
      if Current.session.is_valid_session? &&
         Current.session.ip_address == request.ip &&
         Current.session.user_agent == request.user_agent
        Current.session.refresh!
        render status: :created,
               json: {
                 access_token: create_jwt_for_current_session,
                 refresh_token: Current.session.refresh_token,
                 refresh_token_expires_at: Current.session.refresh_token_expires_at,
               }
        return
      end
    end
    render status: :unauthorized, json: { error: "Invalid or expired token." }
  end

  def sign_out
    Current.session&.revoke!
    Current.session = nil
  end

  private

  def set_session
    params.require(:id)
    @session = Current.user.sessions.find(params.expect(:id))
  end
end
