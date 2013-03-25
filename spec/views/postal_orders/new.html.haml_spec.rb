require 'spec_helper'

describe "postal_orders/new" do
  let(:postal_order) { build(:postal_order) }
  before(:each) do
    assign(:postal_order, postal_order)
  end

  it "renders new postal_order form" do
    view.stub(:ordered_products)
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => postal_orders_path, :method => "post" do
      assert_select ".products .thumbnails"
      assert_select "input#postal_order_username", :name => "postal_order[username]"
      assert_select "input#postal_order_email", :name => "postal_order[email]"
      assert_select "input#postal_order_zipcode", :name => "postal_order[zipcode]"
      assert_select "input#postal_order_country", :name => "postal_order[country]"
      assert_select "input#postal_order_region", :name => "postal_order[region]"
      assert_select "input#postal_order_city", :name => "postal_order[city]"
      assert_select "input#postal_order_street_line", :name => "postal_order[street_line]"
      assert_select "textarea#postal_order_comment", :name => "postal_order[comment]"
      assert_select ".total-price"
    end
  end
end
