class SessionsController < ApplicationController
  skip_authentication! only: %i[create update]
  before_action :set_session, only: %i[show destroy]

  def index
    @sessions = Current.user&.sessions || []
  end

  def show
  end

  def create
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

  def update
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

  def destroy
    @session&.revoke!
    Current.session = nil if @session == Current.session
  end

  private

  def set_session
    id = params[:id]
    @session = id ? Current.user.sessions.find(params.expect(:id)) : Current.session
  end
end
