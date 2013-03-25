require "spec_helper"

describe CategoriesController do
  let(:category) { create(:category) }

  describe "routing" do
    it "routes to #index" do
      get("/categories").should route_to("categories#index")
    end

    it "routes to #new" do
      get("/categories/new").should route_to("categories#new")
    end

    it "routes to #show" do
      get("/#{category.slug}").should route_to("categories#show", :slug => category.slug)
    end

    it "routes to #edit" do
      get("/#{category.slug}/edit").should route_to("categories#edit", :slug => category.slug)
    end

    it "routes to #create" do
      post("/categories").should route_to("categories#create")
    end

    it "routes to #update" do
      put("/#{category.slug}").should route_to("categories#update", :slug => category.slug)
    end

    it "routes to #destroy" do
      delete("/#{category.slug}").should route_to("categories#destroy", :slug => category.slug)
    end

  end
end
