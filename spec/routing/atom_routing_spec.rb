require "spec_helper"

describe AtomController do
  describe "routing" do
    it "routes to #index" do
      get("/products.atom").should route_to("atom#index", format: :atom)
    end
  end
end
