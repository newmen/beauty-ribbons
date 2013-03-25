require "spec_helper"

describe ProductsController do
  describe "routing" do

    Product::STATIC_SCOPES.each do |scope_name|
      it "routes to #{scope_name}" do
        get("/#{scope_name}").should route_to("static_products#index", scope_name.to_sym => true)
      end
    end

  end
end