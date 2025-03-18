require "rails_helper"

RSpec.describe ProfilesController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/profiles/CoolUser123").to route_to("profiles#show", username: "CoolUser123")
      expect(get: "/profile").to route_to("profiles#show")
    end

    it "routes to #create" do
      expect(post: "/profile").to route_to("profiles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/profile").to route_to("profiles#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/profile").to route_to("profiles#update")
    end

    it "routes to #destroy" do
      expect(delete: "/profile").to route_to("profiles#destroy")
    end
  end
end
