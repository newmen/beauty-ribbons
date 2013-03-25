require "spec_helper"

describe CartController do
  let(:product) { create(:product) }

  describe "routing" do
    it "routes to #show" do
      get("/cart").should route_to("cart#show")
    end

    it "routes to #create" do
      post("/cart/#{product.slug}").should route_to("cart#create", product_slug: product.slug, format: :js)
    end

    it "routes to #destroy" do
      delete("/cart/#{product.slug}").should route_to("cart#destroy", product_slug: product.slug, format: :js)
    end
  end
end
