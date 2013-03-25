require "spec_helper"

describe SitemapController do
  describe "routing" do
    it "routes to #index" do
      get("/sitemap.xml").should route_to("sitemap#index", format: :xml)
    end

    it "routes to #show" do
      get("/sitemap").should route_to("sitemap#show")
    end
  end
end
