class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show ]

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      render :show, status: :created, location: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    if @profile.update(profile_params)
      render :show, status: :ok, location: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
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
  def profile_params
    params.fetch(:profile, {})
  end
end
