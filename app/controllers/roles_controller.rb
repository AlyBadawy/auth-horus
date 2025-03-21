class RolesController < ApplicationController
  before_action :set_role, only: %i[ show update destroy ]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    if @role.save
      render :show, status: :created, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    if @role.update(role_params)
      render :show, status: :ok, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.expect(role: [:role_name])
  end
end
