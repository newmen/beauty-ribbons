require "spec_helper"

describe PostalOrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/postal_orders").should route_to("postal_orders#index")
    end

    it "routes to #new" do
      get("/postal_orders/new").should route_to("postal_orders#new")
    end

    it "routes to #edit" do
      get("/postal_orders/1/edit").should route_to("postal_orders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/postal_orders").should route_to("postal_orders#create")
    end

    it "routes to #update" do
      put("/postal_orders/1").should route_to("postal_orders#update", :id => "1")
    end

  end
end
