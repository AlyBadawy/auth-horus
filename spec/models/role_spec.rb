require "rails_helper"

RSpec.describe Role, type: :model do
  describe "validations" do
    it "is valid with a unique role_name" do
      role = described_class.new(role_name: "Admin")
      expect(role).to be_valid
    end

    it "is invalid without a role_name" do
      role = described_class.new(role_name: nil)
      role.valid?
      expect(role.errors[:role_name]).to include("can't be blank")
    end

    it "is invalid with a duplicate role_name" do
      described_class.create!(role_name: "Admin")
      role = described_class.new(role_name: "Admin")
      role.valid?
      expect(role.errors[:role_name]).to include("has already been taken")
    end
  end

  describe "normalizations" do
    it "titleizes the role_name before saving" do
      role = described_class.new(role_name: "  admin  ")
      role.save
      expect(role.role_name).to eq("Admin")
    end
  end
end
