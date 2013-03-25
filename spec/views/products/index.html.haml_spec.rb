require 'spec_helper'

describe "products/index" do
  let(:category) { create(:category) }
  let(:product) { stub_model(Product, valid_attributes) }
  let(:valid_attributes) do
    attributes = attributes_for(:product).select { |_, v| v }
    attributes['category_id'] = category.id
    attributes['cover_id'] = create(:product_image).id
    attributes
  end

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
