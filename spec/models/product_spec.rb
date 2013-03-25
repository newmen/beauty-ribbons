require 'spec_helper'

describe Product do
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:width) }
  it { should validate_numericality_of(:height) }
  it { should validate_numericality_of(:length) }
  it { should validate_numericality_of(:diameter) }

  it_should_behave_like "priceable", :price
  it_should_behave_like "priceable", :old_price

  describe 'badge assignment' do
    let(:conventional_product) { create(:product) }
    let(:badged_product) { create(:badged_product) }
    let(:sale_product) { create(:sale_product) }
    let(:smaller_old_price_product) { create(:smaller_old_price_product) }

    before(:each) do
      create(:badge_nova)
      create(:badge_sale)
    end

    describe 'conventional product' do
      it 'no badges' do
        conventional_product.badge.should be_nil
      end

      it 'no badges if old price less than current price' do
        smaller_old_price_product.badge.should be_nil
      end
    end

    describe 'nova product' do
      before(:each) do
        Settings.reload!
        Settings[:nova_days] = '1'
      end

      after(:each) do
        Settings.reload!
      end

      it 'has the nova badge' do
        conventional_product.badge.should eq Badge.nova
      end

      it "has an another badge if it's set" do
        badged_product.badge.should_not be_nil
        badged_product.badge.should_not eq Badge.nova
      end

      it "has the sale badge if has old price more than current price" do
        sale_product.badge.should eq Badge.sale
      end

      it "has the nova badge if has old price less than current price" do
        smaller_old_price_product.badge.should eq Badge.nova
      end
    end

    describe 'badged product' do
      let(:badged_sale_product) { create(:badged_sale_product) }
      let(:badged_smaller_old_price_product) { create(:badged_smaller_old_price_product) }
      let(:badged_archived_product) { create(:badged_archived_product) }

      it 'has a badge' do
        badged_product.badge.should_not be_nil
        badged_product.badge.should_not eq Badge.nova
        badged_product.badge.should_not eq Badge.sale
      end

      it "has the sale badge if has old price more than current price" do
        badged_sale_product.badge.should eq Badge.sale
      end

      it "has original badge if has old price less than current price" do
        badged_smaller_old_price_product.badge.should_not be_nil
        badged_smaller_old_price_product.badge.should_not eq Badge.sale
      end

      it "has no badge if archived" do
        badged_archived_product.badge.should be_nil
      end
    end
  end

  describe "tagging" do
    it "returns tag list as string of tag names" do
      product = create(:product, tag_list: 'orange, banana, apple')
      product.tag_list.should be_a(String)
      product.tag_list.split(',').map(&:strip).should include('orange', 'banana', 'apple')
    end
  end

  describe 'similar products' do
    [
      %w(white ffffff),
      %w(black 000000),
      %w(silver cccccc),
      %w(gray 999999),
      %w(red ff0000),
      %w(gold ffc800),
      %w(yellow ffff00),
      %w(orange ffa500),
      %w(lime 00ff00),
      %w(blue 0000ff),
    ].each do |name, value|
      let("#{name}_color".to_sym) { create(:color, name: name, value: value) }
    end

    let(:product) do
      p = create(:product, tag_list: 'orange, banana, apple')
      p.colors << yellow_color << orange_color << lime_color
      p
    end

    let(:similar_product) do
      p = create(:product, category: product.category, tag_list: 'apple, orange, ananas')
      p.colors << lime_color << orange_color << white_color
      p
    end

    let(:same_category_product) do
      p = create(:product, category: product.category, tag_list: 'coal, carbon, wood')
      p.colors << black_color << gray_color << silver_color
      p
    end

    let(:another_category) { create(:category, name: 'another category') }
    let(:another_product) do
      p = create(:product, category: another_category, tag_list: 'garnet, persimmon, eggplant')
      p.colors << gold_color << blue_color << red_color
      p
    end

    let(:archived_product) do
      p = create(:archived_product, category: product.category, tag_list: 'apple, ananas, banana')
      p.colors << orange_color << white_color << yellow_color
      p
    end

    before(:each) do
      similar_product
      another_product
    end

    it "returns #{Settings.counts.similar_products} products" do
      product.similar.to_a.should have(Settings.counts.similar_products.to_i).items
    end

    it 'returns products by intersections count' do
      same_category_product

      similar_products = product.similar
      similar_products[0].should eq similar_product
      similar_products[1].should eq same_category_product
    end

    it 'not returns itself' do
      product.similar.should_not include(product)
    end

    it 'returns random products when similar does not exist' do
      random_products = another_product.similar
      random_products.should include(product)
      random_products.should include(similar_product)
    end

    it 'not contain archived product' do
      archived_product
      product.similar.should_not include(archived_product)
    end
  end
end
