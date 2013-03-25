require 'spec_helper'

describe "cart/show.html.haml" do
  let(:category) { create(:category) }
  let(:products_num) { 3 }

  describe 'ordered_products' do
    before(:each) do
      view.stub(:ordered_products).and_return(products_num.times.map { create(:product, category: category) })
      render
    end

    it 'have title' do
      assert_select 'h4', text: "#{I18n.t('cart.show.ordered_products')}:"
    end

    it "have some products" do
      assert_select '.thumbnails' do
        assert_select '.thumbnail.product', count: products_num
      end
    end

    it 'have total price' do
      assert_select '.total-price'
    end

    it 'have checkout button' do
      response.should have_link I18n.t('cart.show.create_postal_order'), href: new_postal_order_path
    end
  end

  describe 'desired_products' do
    before(:each) do
      view.stub(:desired_products).and_return(products_num.times.map { create(:archived_product, category: category) })
      render
    end

    it 'have title' do
      assert_select 'h4', text: "#{I18n.t('cart.show.desired_products')}:"
    end

    it "have some products" do
      assert_select '.thumbnails' do
        assert_select '.thumbnail.archived-product', count: products_num
      end
    end

    it "haven't total price" do
      assert_select '.total-price', 0
    end

    it 'have checkout button' do
      response.should have_link I18n.t('cart.show.create_pre_order'), href: new_pre_order_path
    end
  end
end
