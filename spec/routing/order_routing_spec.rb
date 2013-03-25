require "spec_helper"

describe OrderController do

  describe "routing" do
    it "routes to #update" do
      put("/order/1/complete").should route_to("order#update", id: '1', state: 'complete', format: :js)
    end

    it "routes to #destroy" do
      delete("/order/1").should route_to("order#destroy", id: '1', format: :js)
    end
  end

end
