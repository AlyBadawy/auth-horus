class PasswordsController < ApplicationController
  skip_authentication!
  before_action :set_user_by_password_token, only: %i[ update ]

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    render status: :ok, json: { message: "Password reset instructions sent (if user with that email address exists)." }
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      render status: :ok, json: { message: "Password has been reset." }
    else
      render status: :unprocessable_entity, json: { errors: @user.errors }
    end
  end

  private

  def set_user_by_password_token
    @user = User.find_by!(password_reset_token: params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render status: :unprocessable_entity, json: { errors: { token: "is invalid or has expired" } }
  end
end
