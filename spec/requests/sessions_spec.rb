require "rails_helper"

RSpec.describe "/session[s]", type: :request do
  describe "GET /sessions" do
    it "lists all sessions for the current user" do
      create(:session, user: @signed_in_user)
      get sessions_url, headers: @valid_headers, as: :json
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

    it "return 401 unauthorized when no valid headers" do
      get sessions_url, as: :json
      expect(response).not_to be_successful
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /session[s]" do
    it "shows the session for a given ID (get sessions/:id)" do
      new_session = create(:session, user: @signed_in_user)
      get session_url(new_session), headers: @valid_headers, as: :json
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

    it "shows 404 not found for the wrong session ID (get sessions/:id)" do
      get session_url("wrong"), headers: @valid_headers, as: :json
      expect(response).not_to be_successful
      expect(response).to have_http_status(:not_found)
    end

    it "shows the session for current session (get session)" do
      get current_session_url, headers: @valid_headers, as: :json
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

    it "return 401 unauthorized when no valid headers" do
      get current_session_url, as: :json
      expect(response).not_to be_successful
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /session" do
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
        post current_session_url, params: valid_attributes, headers: headers, as: :json
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
        post current_session_url, params: invalid_attributes, headers: headers, as: :json
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
        put current_session_url, params: valid_attributes, headers: headers, as: :json
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
        put current_session_url, params: invalid_attributes, headers: headers, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include("error")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:new_user) { create(:user, password: "password") }
    let(:new_session) { create(:session, user: new_user) }
    let(:another_session) { create(:session, user: new_user) }
    let(:new_valid_headers) {
      token = JwtHelper.encode(new_session)
      { "Authorization" => "Bearer #{token}", "User-Agent" => "RSpec" }
    }

    it "destroys the current session" do
      delete current_session_url, headers: new_valid_headers, as: :json
      new_session.reload
      expect(new_session.revoked).to be_truthy
      expect(response).to have_http_status(:no_content)
    end

    it "destroys the requested session" do
      delete session_url(another_session), headers: new_valid_headers, as: :json
      another_session.reload
      expect(another_session.revoked).to be_truthy
      expect(response).to have_http_status(:no_content)
    end

    it "return 401 unauthorized when no valid headers" do
      delete current_session_url, as: :json
      expect(response).not_to be_successful
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
