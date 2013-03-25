require 'spec_helper'

describe "postal_orders/index" do
  let(:postal_order) { stub_model(PostalOrder, attributes_for(:postal_order)) }

  before(:each) do
    assign(:postal_orders, [postal_order, postal_order])
  end

  it "renders a list of postal_orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => postal_order.id.to_s, :count => 2
    assert_select "tr>td", :text => postal_order.complete_address.to_s, :count => 2
  end
end
