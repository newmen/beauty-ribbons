require 'spec_helper'

describe CartController do

  let(:product) { create(:product) }
  let(:archived_product) { create(:archived_product) }

  subject(:store_product) { controller.stored_product_ids << product.id }

  describe "GET 'show'" do
    it "redirects if no stored products" do
      get :show
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "returns http success if has stored product" do
      store_product
      get :show
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      post :create, product_slug: product.slug, format: :js
      response.should be_success
    end

    it "saves passed product_id in session" do
      post :create, product_slug: product.slug, format: :js
      controller.stored_product_ids.should have(1).items
      controller.stored_product_ids.should include(product.id)
    end

    it "not archived product available as availabled" do
      post :create, product_slug: product.slug, format: :js
      controller.ordered_products.should have(1).items
      controller.ordered_products.should include(product)
      controller.desired_products.should be_nil
    end

    it "archived product available as desired" do
      post :create, product_slug: archived_product.slug, format: :js
      controller.desired_products.should have(1).items
      controller.desired_products.should include(archived_product)
      controller.ordered_products.should be_nil
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      delete :destroy, product_slug: product.slug, format: :js
      response.should be_success
    end

    it "removes passed product_id from session" do
      store_product
      delete :destroy, product_slug: product.slug, format: :js
      controller.stored_product_ids.should be_empty
    end
  end

end
