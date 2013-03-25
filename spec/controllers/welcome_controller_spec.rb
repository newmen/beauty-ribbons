require 'spec_helper'

describe WelcomeController do

  describe "GET 'index'" do
    let(:page) { create(:welcome_page) }
    before(:each) { page }

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns welcome page as @page" do
      get 'index'
      assigns(:page).should eq(page)
    end

    it 'assigns random products as @products' do
      category = create(:category)
      sale_product = create(:sale_product, category: category)
      archived_product = create(:archived_product, category: category)
      Settings.counts.welcome_products.to_i.times do |i|
        create(:product, category: category, name: "product #{i}")
      end

      get 'index'
      assigns(:products).should include(sale_product)
      assigns(:products).should_not include(archived_product)
    end
  end

end
