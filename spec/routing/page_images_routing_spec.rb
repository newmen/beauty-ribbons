require "spec_helper"

describe PageImagesController do

  describe "routing" do
    it "routes to #create" do
      post("/page_images").should route_to("page_images#create", format: :js)
    end

    it "routes to #destroy" do
      delete("/page_images/1").should route_to("page_images#destroy", id: "1", format: :js)
    end
  end

end
