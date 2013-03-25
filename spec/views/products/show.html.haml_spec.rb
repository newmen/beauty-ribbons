require 'spec_helper'

describe "products/show" do
  let(:product) { create(:product) }
  before(:each) do
    assign(:product, product)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match product.name.to_s
    rendered.should match product.description.to_s
    rendered.should match product.width.to_s
    rendered.should match product.height.to_s
  end

  it_behaves_like 'see_or_not_edit_button'
  it_behaves_like 'see_or_not_destroy_button'
end
