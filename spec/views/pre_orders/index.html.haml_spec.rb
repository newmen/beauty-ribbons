require 'spec_helper'

describe "pre_orders/index" do
  let(:pre_order) { stub_model(PreOrder, attributes_for(:pre_order)) }

  before(:each) do
    assign(:pre_orders, [pre_order, pre_order])
  end

  it "renders a list of pre_orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => pre_order.id.to_s, :count => 2
  end
end
