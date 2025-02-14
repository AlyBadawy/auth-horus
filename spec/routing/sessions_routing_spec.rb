require "rails_helper"

RSpec.describe SessionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sessions").to route_to("sessions#index")
    end

    it "routes to #show" do
      expect(get: "/session").to route_to("sessions#show")
      expect(get: "/sessions/1").to route_to("sessions#show", id: "1")
    end

    it "routes to #create (sign_in)" do
      expect(post: "/session").to route_to("sessions#create")
    end

    it "routes to #update (refresh) via PUT" do
      expect(put: "/session").to route_to("sessions#update")
    end

    it "routes to #update (refresh) via PATCH" do
      expect(patch: "/session").to route_to("sessions#update")
    end

    it "routes to #destroy" do
      expect(delete: "/session").to route_to("sessions#destroy")
      expect(delete: "/sessions/1").to route_to("sessions#destroy", id: "1")
    end
  end
end
