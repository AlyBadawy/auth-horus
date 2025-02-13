require "rails_helper"

RSpec.describe SessionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/identity/").to route_to("sessions#index")
    end

    it "routes to #show" do
      expect(get: "/identity/1").to route_to("sessions#show", id: "1")
    end

    it "routes to #sign_in" do
      expect(post: "/identity/sign_in").to route_to("sessions#sign_in")
    end

    it "routes to #refresh via PUT" do
      expect(put: "/identity/refresh").to route_to("sessions#refresh")
    end

    it "routes to #sign_out" do
      expect(delete: "/identity/sign_out").to route_to("sessions#sign_out")
    end
  end
end
