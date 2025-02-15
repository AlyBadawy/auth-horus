require "rails_helper"

RSpec.describe "/passwords", type: :request do
  describe "POST /passwords" do
    it "Always shows a successful response" do
      post passwords_url, params: { email_address: @signed_in_user.email_address }
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(
        {
          "message" => "Password reset instructions sent (if user with that email address exists).",
        }
      )
    end

    it "Send an email if the user exists" do
      allow(PasswordsMailer).to receive(:reset).and_call_original
      post passwords_url, params: { email_address: @signed_in_user.email_address }
      expect(PasswordsMailer).to have_received(:reset).with(@signed_in_user).exactly(1)
    end

    it "Doesn't send an email if the user doesn't exist" do
      allow(PasswordsMailer).to receive(:reset).and_call_original
      post passwords_url, params: { email_address: "wrong@email.com" }
      expect(PasswordsMailer).to have_received(:reset).with(@signed_in_user).exactly(0)
    end
  end

  describe "PUT /passwords" do
    context "when Correct token for a user is provided" do
      it "renders a successful response" do
        token = @signed_in_user.password_reset_token
        put password_url(token), params: {
                                   password: "new_password",
                                   password_confirmation: "new_password",
                                 }
        expect(response).to be_successful
      end

      it "resets the password when password is valid" do
        expect(
          User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "new_password",
          )
        ).to be_nil
        token = @signed_in_user.password_reset_token
        put password_url(token), params: {
                                   password: "new_password",
                                   password_confirmation: "new_password",
                                 }
        expect(JSON.parse(response.body)).to eq(
          { "message" => "Password has been reset." }
        )
        expect(
          User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "new_password",
          )
        ).to eq(@signed_in_user)
      end

      it "doesn't reset the password when password is invalid" do
        expect(
          User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "new_password",
          )
        ).to be_nil
        token = @signed_in_user.password_reset_token
        put password_url(token), params: {
                                   password: "new_password",
                                   password_confirmation: "incorrect",
                                 }
        expect(JSON.parse(response.body)).to eq(
          { "errors" => { "password_confirmation" => ["doesn't match Password"] } }
        )
        expect(
          User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "new_password",
          )
        ).to be_nil
      end
    end

    context "when Incorrect token for a user is provided" do
      it "renders a unprocessable_entity response" do
        put password_url("invalid_token"),
            params: {
              password: "new_password",
              password_confirmation: "new_password",
            }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          { "errors" => { "token" => "is invalid or has expired" } }
        )
      end

      it "Doesn't reset the password" do
        expect(
          User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "password",
          )
        ).to eq(@signed_in_user)
        put password_url("invalid_token"),
            params: {
              password: "new_password",
              password_confirmation: "new_password",
            }
        expect(
          User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "new_password",
          )
        ).to be_nil

        expect(
          User.authenticate_by(
            email_address: @signed_in_user.email_address,
            password: "password",
          )
        ).to eq(@signed_in_user)
      end
    end
  end
end
