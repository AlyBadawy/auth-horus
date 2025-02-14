require "rails_helper"

RSpec.describe PasswordsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/passwords").to route_to("passwords#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/passwords/1").to route_to("passwords#update", token: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/passwords/1").to route_to("passwords#update", token: "1")
    end
  end
end
