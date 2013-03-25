require 'spec_helper'

describe "postal_orders/edit" do
  let(:postal_order) { create(:postal_order) }
  before(:each) do
    assign(:postal_order, postal_order)
  end

  it "renders attributes like a form" do
    render

    assert_select ".products .thumbnails"
    rendered.should match(/#{postal_order.username}/)
    rendered.should match(/#{postal_order.email}/)
    rendered.should match(/#{postal_order.zipcode}/)
    rendered.should match(/#{postal_order.city}/)
    rendered.should match(/#{postal_order.street_line}/)
    rendered.should match(/#{postal_order.comment}/)
  end

  it "renders the edit postal_order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => postal_orders_path(@postal_order), :method => "post" do
      assert_select "input#postal_order_amount", :name => "postal_order[amount]"
      assert_select "textarea#postal_order_note", :name => "postal_order[note]"
    end
  end
end
