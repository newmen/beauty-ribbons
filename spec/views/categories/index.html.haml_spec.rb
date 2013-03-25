require 'spec_helper'

describe "categories/index" do
  let(:category) { stub_model(Category, attributes_for(:category)) }

  before(:each) do
    assign(:categories, [category, category])
  end

  it "renders a list of categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => category.name.to_s, :count => 2
  end
end
