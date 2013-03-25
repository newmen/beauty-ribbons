require "spec_helper"

describe ProductImagesController do

  describe "routing" do
    it "routes to #create" do
      post("/product_images").should route_to("product_images#create", format: :js)
    end

    it "routes to #destroy" do
      delete("/product_images/1").should route_to("product_images#destroy", id: "1", format: :js)
    end
  end

end
