require 'spec_helper'

describe CartHelper do
  let(:category) { create(:category) }
  let(:archived_product) { create(:archived_product, category: category) }

  describe 'basic stored products methods' do
    subject(:add_store_product) { helper.stored_product_ids << create(:product).id }

    describe '#stored_product_ids' do
      it 'always is Array' do
        helper.stored_product_ids.should be_an_instance_of Array
        helper.stored_product_ids.should be_empty
      end

      it 'not empty when at least one product is stored' do
        add_store_product
        helper.stored_product_ids.should_not be_empty
      end
    end

    describe '#has_stored_products?' do
      it "false when products aren't stored" do
        helper.has_stored_products?.should be_false
      end

      it 'true when products are stored' do
        add_store_product
        helper.has_stored_products?.should be_true
      end
    end

    describe '#stored_products_num' do
      it "zero when products aren't stored" do
        helper.stored_products_num.should eq 0
      end

      it 'one when one product is stored' do
        add_store_product
        helper.stored_products_num.should eq 1
      end
    end
  end

  describe 'several type of products' do
    let(:unarchived_product) { create(:product, category: category) }
    before(:each) do
      helper.stored_product_ids << unarchived_product.id << archived_product.id
    end

    describe '#ordered_products' do
      it 'contain only unarchived products' do
        helper.ordered_products.should include unarchived_product
        helper.ordered_products.should_not include archived_product
      end
    end

    describe '#desired_products' do
      it 'contain only archived products' do
        helper.desired_products.should_not include unarchived_product
        helper.desired_products.should include archived_product
      end
    end
  end

  describe 'have many products' do
    let(:products) { 3.times.map { create(:product, category: category) } }

    describe '#unstore_products' do
      it 'remove passed products from session' do
        products.each { |p| helper.stored_product_ids << p.id }
        helper.unstore_products(products)
        helper.stored_product_ids.should be_empty
      end
    end

    describe '#ids_corresponds_to_products' do
      it 'when has array of stringify product ids and products array' do
        shuffled_ids_str = products.map(&:id).map(&:to_s).shuffle
        helper.ids_corresponds_to_products(shuffled_ids_str, products).should be_true
      end
    end

    describe '#total_price' do
      it "returns sum of real product prices without archived products" do
        real_products_total_price = products.map(&:price).map(&:to_f).inject(:+).to_i
        products << archived_product
        products.map { |product| helper.stored_product_ids << product.id }

        helper.total_price.gsub(' ', '').to_i.should eq real_products_total_price
      end

      it "returns pre_order text" do
        helper.stored_product_ids << create(:archived_product).id
        helper.total_price.should eq I18n.t('cart.buttons.pre_order')
      end

      it "don't return some text" do
        helper.total_price.should be_nil
      end
    end
  end

  describe 'icon css classes' do
    it '#postal_order_icon_css_class' do
      helper.postal_order_icon_css_class.should eq 'icon-shopping-cart'
    end

    it '#pre_order_icon_css_class' do
      helper.pre_order_icon_css_class.should eq 'icon-tag'
    end
  end

  describe '#cart_bottom_icons' do
    subject { helper.cart_bottom_icons }
    let(:postal_order_icon) { 'i.icon-shopping-cart.icon-white' }
    let(:pre_order_icon) { 'i.icon-tag.icon-white' }

    def fill_stored_products(unarchived_nums, archived_nums)
      unarchived_nums.times do
        helper.stored_product_ids << create(:product, category: category).id
      end
      archived_nums.times do
        helper.stored_product_ids << create(:archived_product, category: category).id
      end
    end

    it 'one unarchived and one archived products' do
      fill_stored_products(1, 1)
      should have_selector postal_order_icon, count: 1
      should have_selector pre_order_icon, count: 1
    end

    it 'two unarchived and two archived products' do
      fill_stored_products(2, 2)
      should have_selector postal_order_icon, count: 2
      should have_selector pre_order_icon, count: 2
    end

    it 'three unarchived and two archived products' do
      fill_stored_products(3, 2)
      should have_selector postal_order_icon, count: 3
      should have_selector pre_order_icon, count: 1
    end

    it 'one unarchived and five archived products' do
      fill_stored_products(1, 5)
      should have_selector postal_order_icon, count: 1
      should have_selector pre_order_icon, count: 3
    end

    it 'only seven unarchived products' do
      fill_stored_products(7, 0)
      should have_selector postal_order_icon, count: 4
      should_not have_selector pre_order_icon
    end

    it 'only six archived products' do
      fill_stored_products(0, 6)
      should_not have_selector postal_order_icon
      should have_selector pre_order_icon, count: 4
    end
  end

  describe 'buttons' do
    let(:product) { create(:product, category: category) }

    describe '#buy_button' do
      subject { helper.buy_button(product) }
      let(:add_to_cart_btn) { 'a.add_to_cart.btn.btn-primary' }
      let(:remove_from_cart_btn) { 'a.remove_from_cart.btn.btn-danger' }

      it "product isn't added" do
        should have_selector add_to_cart_btn, visible: true
        should have_selector remove_from_cart_btn, visible: false
      end

      it "product already added" do
        helper.stored_product_ids << product.id
        should have_selector add_to_cart_btn, visible: false
        should have_selector remove_from_cart_btn, visible: true
      end
    end

    describe '#pre_order_button' do
      subject { helper.pre_order_button(product) }
      let(:add_to_cart_btn) { 'a.add_to_cart.btn.btn-info' }
      let(:remove_from_cart_btn) { 'a.remove_from_cart.btn' }

      it "product isn't added" do
        should have_selector add_to_cart_btn, visible: true
        should have_selector remove_from_cart_btn, visible: false
      end

      it "product already added" do
        helper.stored_product_ids << product.id
        should have_selector add_to_cart_btn, visible: false
        should have_selector remove_from_cart_btn, visible: true
      end
    end
  end

  describe '#products_mosaic' do
    def create_products(num)
      num.times.map { create(:product, category: category) }
    end

    def assert_products_rows(creating_products_num, *products_nums)
      result = helper.products_mosaic(create_products(creating_products_num))
      products_nums.each do |num|
        result.should have_selector 'div.thumbnails' do |row|
          row.should have_selector 'img', num
        end
      end
    end

    it('3 products in one row') { assert_products_rows(3, 3) }
    it('4 products in one row') { assert_products_rows(4, 4) }
    it('5 products in two row') { assert_products_rows(5, 3, 2) }
    it('6 products in two row') { assert_products_rows(6, 3, 3) }
    it('7 products in two row') { assert_products_rows(7, 4, 3) }
    it('8 products in two row') { assert_products_rows(8, 4, 4) }
    it('9 products in three row') { assert_products_rows(9, 4, 3, 2) }
    it('10 products in three row') { assert_products_rows(10, 4, 3, 3) }
  end
end
