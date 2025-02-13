require "rails_helper"

RSpec.describe "/identity", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      create(:session, user: @signed_in_user)
      get my_sessions_url, headers: @valid_headers, as: :json
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      expect(JSON.parse(response.body).first).to include(
        "id",
        "refresh_count",
        "refresh_token",
        "refresh_token_expires_at",
        "last_refreshed_at",
        "revoked"
      )
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      new_session = create(:session, user: @signed_in_user)
      get my_session_url(new_session), headers: @valid_headers, as: :json
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include(
        "id",
        "refresh_count",
        "refresh_token",
        "refresh_token_expires_at",
        "last_refreshed_at",
        "revoked"
      )
    end
  end

  describe "POST /sign_in" do
    let(:new_user) { create(:user, password: "password") }
    let(:new_session) { create(:session, user: new_user) }
    let(:new_valid_headers) {
      token = JwtHelper.encode(new_session)
      { "Authorization" => "Bearer #{token}" }
    }
    let(:valid_attributes) {
      { email_address: new_user.email_address, password: "password" }
    }

    let(:invalid_attributes) {
      { email_address: new_user.email_address, password: "wrong_password" }
    }

    context "with valid parameters" do
      it "signs in the user and returns tokens" do
        headers = { "User-Agent" => "RSpec" }
        post sign_in_url, params: valid_attributes, headers: headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include(
          "access_token",
          "refresh_token",
          "refresh_token_expires_at"
        )
      end
    end

    context "with invalid parameters" do
      it "returns unauthorized status" do
        headers = { "User-Agent" => "RSpec" }
        post sign_in_url, params: invalid_attributes, headers: headers, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include("error")
      end
    end
  end

  describe "POST /refresh" do
    let(:new_user) { create(:user, password: "password") }
    let(:new_session) { create(:session, user: new_user) }
    let(:valid_attributes) {
      { refresh_token: new_session.refresh_token }
    }

    let(:invalid_attributes) {
      { refresh_token: "invalid_token" }
    }

    context "with valid parameters" do
      it "refreshes the session and returns new tokens" do
        headers = { "User-Agent" => "RSpec" }
        put refresh_url, params: valid_attributes, headers: headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include(
          "access_token",
          "refresh_token",
          "refresh_token_expires_at"
        )
      end
    end

    context "with invalid parameters" do
      it "returns unauthorized status" do
        headers = { "User-Agent" => "RSpec" }
        put refresh_url, params: invalid_attributes, headers: headers, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include("error")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:new_user) { create(:user, password: "password") }
    let(:new_session) { create(:session, user: new_user) }
    let(:new_valid_headers) {
      token = JwtHelper.encode(new_session)
      { "Authorization" => "Bearer #{token}", "User-Agent" => "RSpec" }
    }

    it "destroys the requested session" do
      delete sign_out_url, headers: new_valid_headers, as: :json
      new_session.reload
      expect(new_session.revoked).to be_truthy
      expect(response).to have_http_status(:no_content)
    end
  end
end
