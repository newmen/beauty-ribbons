require 'spec_helper'

describe "pre_orders/new" do
  let(:pre_order) { build(:pre_order) }
  before(:each) do
    assign(:pre_order, pre_order)
  end

  it "renders new pre_order form" do
    view.stub(:desired_products)
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pre_orders_path, :method => "post" do
      assert_select ".products .thumbnails"
      assert_select "input#pre_order_username", :name => "pre_order[username]"
      assert_select "input#pre_order_email", :name => "pre_order[email]"
      assert_select "input#pre_order_expected_cost", :name => "pre_order[expected_cost]"
      assert_select "textarea#pre_order_comment", :name => "pre_order[comment]"
    end
  end
end
