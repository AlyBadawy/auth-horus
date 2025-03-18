class ProfilesController < ApplicationController
  skip_authentication! only: [:create]
  before_action :set_profile, only: %i[ show ]

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @user = User.new(user_params)
    @user.build_profile(profile_params)
    if @user.save
      @profile = @user.profile
      render :show, status: :created, location: @profile
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    if @user.update(user_params)
      @profile = @user.profile
      render :show, status: :created, location: @profile
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    if user = Current.user.authenticate(params.require(:password))
      user.destroy!
      Current.session = nil
    else
      render status: :bad_request, json: {
        error: "Unable to verify your account",
        fix: "Make sure you entered the correct password",
      }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    username = params[:username]
    @profile = username ? Profile.find_by(username: username) : Current.profile
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.expect(user: [:email_address, :password, :password_confirmation])
  end

  def profile_params
    params.expect(profile: [:first_name, :last_name, :phone, :username])
  end
end
