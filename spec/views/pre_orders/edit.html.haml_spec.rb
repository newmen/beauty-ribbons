require 'spec_helper'

describe "pre_orders/edit" do
  let(:pre_order) { create(:pre_order) }
  before(:each) do
    assign(:pre_order, pre_order)
  end

  it "renders attributes like a form" do
    render

    assert_select ".products .thumbnails"
    rendered.should match(/#{pre_order.username}/)
    rendered.should match(/#{pre_order.email}/)
    rendered.should match(/#{pre_order.comment}/)
  end

  it "renders the edit pre_order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pre_orders_path(@pre_order), :method => "post" do
      assert_select "textarea#pre_order_note", :name => "pre_order[note]"
    end
  end
end
