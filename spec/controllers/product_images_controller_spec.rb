require 'spec_helper'

describe ProductImagesController do

  let(:product_image) { create(:product_image) }
  let(:valid_attributes) { attributes_for(:product_image) }

  describe "unauthorized user" do
    describe "POST create" do
      it_should_behave_like "unauthorized_explained" do
        subject(:connect) { post :create, product_image: valid_attributes, format: :js }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "unauthorized_explained" do
        subject(:connect) { delete :destroy, id: product_image.to_param, format: :js }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "POST create" do
      it "creates a new ProductImage" do
        expect {
          post :create, product_image: valid_attributes, format: :js
        }.to change(ProductImage, :count).by(1)
      end

      it "assigns a newly created product_image as @product_image" do
        post :create, product_image: valid_attributes, format: :js
        assigns(:product_image).should be_a(ProductImage)
        assigns(:product_image).should be_persisted
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested product_image" do
        product_image # create product_image
        expect {
          delete :destroy, id: product_image.to_param, format: :js
        }.to change(ProductImage, :count).by(-1)
      end
    end
  end

end
