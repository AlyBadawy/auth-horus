require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_and_belong_to_many(:roles) }
    it { is_expected.to have_one(:profile) }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = described_class.new(
        email_address: "test@example.com",
        password: "password",
        password_confirmation: "password",

      )
      expect(user).to be_valid
    end

    it "is not valid without an email_address" do
      user = described_class.new(email_address: nil, password: "password", password_confirmation: "password")
      expect(user).not_to be_valid
    end

    it "is not valid with a duplicate email_address" do
      described_class.create(email_address: "test@example.com", password: "password", password_confirmation: "password")
      user = described_class.new(email_address: "test@example.com", password: "password", password_confirmation: "password")
      expect(user).not_to be_valid
    end
  end

  describe "email normalization" do
    it "normalizes the email address before saving" do
      user = described_class.create(email_address: " TEST@EXAMPLE.COM ", password: "password", password_confirmation: "password")
      expect(user.email_address).to eq("test@example.com")
    end
  end

  describe "password encryption" do
    it "encrypts the password" do
      user = described_class.create(email_address: "test@example.com", password: "password", password_confirmation: "password")
      expect(user.password_digest).not_to eq("password")
    end
  end

  describe "password authorization" do
    it "authenticate user by password" do
      user = FactoryBot.create(:user, password: "secure_password", password_confirmation: "secure_password")
      expect(described_class.authenticate_by(email_address: user.email_address, password: "invalid_password")).to be_nil
      expect(described_class.authenticate_by(email_address: user.email_address, password: "secure_password")).to eq(user)
    end
  end
end
