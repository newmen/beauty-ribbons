require "spec_helper"

describe PreOrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/pre_orders").should route_to("pre_orders#index")
    end

    it "routes to #new" do
      get("/pre_orders/new").should route_to("pre_orders#new")
    end

    it "routes to #edit" do
      get("/pre_orders/1/edit").should route_to("pre_orders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pre_orders").should route_to("pre_orders#create")
    end

    it "routes to #update" do
      put("/pre_orders/1").should route_to("pre_orders#update", :id => "1")
    end

  end
end
