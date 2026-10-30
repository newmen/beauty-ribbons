require 'spec_helper'

describe "products/index" do
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }

  before(:each) do
    assign(:products, [product, product])
  end

  it "renders a list of products" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => category.name.to_s, :count => 2
    assert_select "tr>td", :text => product.name.to_s, :count => 2
  end
end
