require 'spec_helper'

describe "colors/index" do
  let(:color) { stub_model(Color, attributes_for(:color)) }

  before(:each) do
    assign(:colors, [color, color])
  end

  it "renders a list of colors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => color.name.to_s, :count => 2
  end
end
