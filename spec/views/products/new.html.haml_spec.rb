require 'spec_helper'

describe "products/new" do
  let(:product) { build(:product) }
  before(:each) do
    assign(:product, product)
  end

  it "renders new product form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => products_path, :method => "post" do
      assert_select "select#product_category_id", :name => "product[category_id]"
      assert_select "input#product_name", :name => "product[name]"
      assert_select "textarea#product_description", :name => "product[description]"
      assert_select "input#product_tag_list", :name => "product[tag_list]"
      assert_select "input#product_width", :name => "product[width]"
      assert_select "input#product_height", :name => "product[height]"
      assert_select "input#product_length", :name => "product[length]"
      assert_select "input#product_diameter", :name => "product[diameter]"
      assert_select "input#product_price", :name => "product[price]"
      assert_select "input#product_old_price", :name => "product[old_price]"
      assert_select "select#product_badge_id", :name => "product[badge_id]"
      assert_select "input#product_is_archived", :name => "product[is_archived]"
    end
  end
end
