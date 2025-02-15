require "rails_helper"

RSpec.describe "/admin/users", type: :request do
  let(:valid_attributes) {
    {
      email_address: "test@example.com",
      password: "password",
      password_confirmation: "password",
    }
  }

  let(:invalid_attributes) {
    {
      email_address: "test@example.com",
      password: "password",
      password_confirmation: "invalid",
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      User.create! valid_attributes
      get users_url, headers: @valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get user_url(user), as: :json, headers: @valid_headers
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url,
               params: { user: valid_attributes }, headers: @valid_headers, as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post users_url,
             params: { user: valid_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post users_url,
               params: { user: invalid_attributes }, as: :json
        }.not_to change(User, :count)
      end

      it "renders a JSON response with errors for the new user" do
        post users_url,
             params: { user: invalid_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          email_address: "new_user@example.com",
          role_ids: [role.id],
          profile_attributes: { first_name: "New", last_name: "User" },
        }
      }
      let(:role) { create(:role, role_name: "Admin") }

      it "updates the requested user and assigns roles" do
        user = User.create! valid_attributes
        patch user_url(user),
              params: { user: new_attributes }, headers: @valid_headers, as: :json
        user.reload
        expect(user.email_address).to eq("new_user@example.com")
        expect(user.roles).to include(role)
      end

      it "renders a JSON response with the user" do
        user = User.create! valid_attributes
        patch user_url(user),
              params: { user: new_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "renders a json with the user's profile and roles" do
        user = User.create! valid_attributes
        patch user_url(user),
              params: { user: new_attributes }, headers: @valid_headers, as: :json
        json_response = JSON.parse(response.body)
        expect(json_response["roles"].first["role_name"]).to eq("Admin")
        expect(json_response["profile"]["email_address"]).to eq("new_user@example.com")
        expect(json_response["profile"]["first_name"]).to eq("New")
        expect(json_response["profile"]["last_name"]).to eq("User")
      end

      it "creates a profile if one doesn't exist" do
        user = User.create! valid_attributes
        patch user_url(user),
              params: { user: new_attributes }, headers: @valid_headers, as: :json
        user.reload
        expect(user.profile).not_to be_nil
        expect(user.profile.first_name).to eq("New")
        expect(user.profile.last_name).to eq("User")
      end

      it "updates the profile if one exists" do
        user = User.create! valid_attributes
        user.create_profile(first_name: "Old", last_name: "Name")
        patch user_url(user),
              params: { user: new_attributes }, headers: @valid_headers, as: :json
        user.reload
        expect(user.profile.first_name).to eq("New")
        expect(user.profile.last_name).to eq("User")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the user" do
        user = User.create! valid_attributes
        patch user_url(user),
              params: { user: invalid_attributes }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete user_url(user), headers: @valid_headers, as: :json
      }.to change(User, :count).by(-1)
    end
  end
end
