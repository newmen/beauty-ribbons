require "spec_helper"

describe ProductsController do
  let(:product) { create(:product) }
  let(:category) { product.category }

  describe "routing" do
    it "routes to #index" do
      get("/products").should route_to("products#index")
    end

    it "routes to #new without category slug" do
      get("/products/new").should route_to("products#new")
    end

    it "routes to #new with category slug" do
      get("/#{category.slug}/products/new").should route_to("products#new", category_slug: category.slug)
    end

    it "routes to #show" do
      get("/#{category.slug}/#{product.slug}").should route_to("products#show", category_slug: category.slug, slug: product.slug)
    end

    it "routes to #edit" do
      get("/#{category.slug}/#{product.slug}/edit").should route_to("products#edit", category_slug: category.slug, slug: product.slug)
    end

    it "routes to #create" do
      post("/products").should route_to("products#create")
    end

    it "routes to #update" do
      put("/products/1").should route_to("products#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/#{category.slug}/#{product.slug}").should route_to("products#destroy", category_slug: category.slug, slug: product.slug)
    end

  end
end
