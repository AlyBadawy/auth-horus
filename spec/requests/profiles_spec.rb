require "rails_helper"

RSpec.describe "/profiles", type: :request do
  describe "GET /show" do
    context "when showing current user's profile" do
      let(:expected_response) {
        {
          "id" => @signed_in_profile.id,
          "email_address" => @signed_in_user.email_address,
          "first_name" => @signed_in_profile.first_name,
          "last_name" => @signed_in_profile.last_name,
          "phone" => @signed_in_profile.phone,
          "username" => @signed_in_profile.username,
          "url" => profile_url(@signed_in_profile, format: :json),
        }
      }

      it "renders a successful response" do
        get current_profile_url, headers: @valid_headers, as: :json
        expect(response).to be_successful
      end

      it "renders the current user's profile" do
        get current_profile_url, headers: @valid_headers, as: :json
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end

    context "when showing other user's profile" do
      let(:user) { create(:user) }
      let(:profile) { create(:profile, user: user) }
      let(:expected_response) {
        {
          "id" => profile.id,
          "email_address" => user.email_address,
          "first_name" => profile.first_name,
          "last_name" => profile.last_name,
          "phone" => profile.phone,
          "username" => profile.username,
          "url" => profile_url(profile, format: :json),
        }
      }

      it "renders a successful response" do
        get profile_url(profile.username), headers: @valid_headers, as: :json
        expect(response).to be_successful
      end

      it "renders the current user's profile" do
        get profile_url(profile.username), headers: @valid_headers, as: :json
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end

  # describe "POST /create" do
  #   context "with valid parameters" do
  #     it "creates a new Profile" do
  #       expect {
  #         post profiles_url,
  #              params: { profile: valid_attributes }, headers: valid_headers, as: :json
  #       }.to change(Profile, :count).by(1)
  #     end

  #     it "renders a JSON response with the new profile" do
  #       post profiles_url,
  #            params: { profile: valid_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:created)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "does not create a new Profile" do
  #       expect {
  #         post profiles_url,
  #              params: { profile: invalid_attributes }, as: :json
  #       }.to change(Profile, :count).by(0)
  #     end

  #     it "renders a JSON response with errors for the new profile" do
  #       post profiles_url,
  #            params: { profile: invalid_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end
  # end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested profile" do
  #       profile = Profile.create! valid_attributes
  #       patch profile_url(profile),
  #             params: { profile: new_attributes }, headers: valid_headers, as: :json
  #       profile.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "renders a JSON response with the profile" do
  #       profile = Profile.create! valid_attributes
  #       patch profile_url(profile),
  #             params: { profile: new_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:ok)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a JSON response with errors for the profile" do
  #       profile = Profile.create! valid_attributes
  #       patch profile_url(profile),
  #             params: { profile: invalid_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end
  # end

  describe "DELETE /destroy" do
    context "when the correct password is provided" do
      it "renders a no_content response" do
        delete current_profile_url, params: { password: "password" }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:no_content)
      end

      it "destroys the current profile" do
        current_profile_id = @signed_in_profile.id
        expect {
          delete current_profile_url, params: { password: "password" }, headers: @valid_headers, as: :json
        }.to change(Profile, :count).by(-1)
        expect(Profile.find_by(id: current_profile_id)).to be_nil
      end

      it "destroys the current user" do
        current_user_id = @signed_in_user.id
        expect {
          delete current_profile_url, params: { password: "password" }, headers: @valid_headers, as: :json
        }.to change(User, :count).by(-1)
        expect(User.find_by(id: current_user_id)).to be_nil
      end
    end

    context "when an incorrect password is provided" do
      it "renders a no_content response" do
        delete current_profile_url, params: { password: "wrong" }, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:bad_request)
      end

      it "doesn't destroy the current profile" do
        expect {
          delete current_profile_url, params: { password: "wrong" }, headers: @valid_headers, as: :json
        }.not_to change(Profile, :count)
      end

      it "destroys the current user" do
        expect {
          delete current_profile_url, params: { password: "wrong" }, headers: @valid_headers, as: :json
        }.not_to change(User, :count)
      end
    end

    context "when password is missing" do
      it "renders a no_content response" do
        delete current_profile_url, headers: @valid_headers, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ error: "param is missing or the value is empty or invalid: password" }.to_json)
      end

      it "doesn't destroy the current profile" do
        expect {
          delete current_profile_url, headers: @valid_headers, as: :json
        }.not_to change(Profile, :count)
      end

      it "destroys the current user" do
        expect {
          delete current_profile_url, headers: @valid_headers, as: :json
        }.not_to change(User, :count)
      end
    end
  end
end
