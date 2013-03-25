require 'spec_helper'

describe PageImagesController do

  let(:valid_attributes) { attributes_for(:page_image) }
  let(:page_image) { create(:page_image) }

  describe "unauthorized user" do
    describe "POST create" do
      it_should_behave_like "unauthorized_explained" do
        subject(:connect) { post :create, page_image: valid_attributes, format: :js }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "unauthorized_explained" do
        subject(:connect) { delete :destroy, id: page_image.to_param, format: :js }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "POST create" do
      it "creates a new PageImage" do
        expect {
          post :create, page_image: valid_attributes, format: :js
        }.to change(PageImage, :count).by(1)
      end

      it "assigns a newly created page_image as @page_image" do
        post :create, page_image: valid_attributes, format: :js
        assigns(:page_image).should be_a(PageImage)
        assigns(:page_image).should be_persisted
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested page_image" do
        page_image # create page_image
        expect {
          delete :destroy, id: page_image.to_param, format: :js
        }.to change(PageImage, :count).by(-1)
      end
    end
  end

end
