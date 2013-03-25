require 'spec_helper'

describe "colors/new" do
  let(:color) { build(:color) }
  before(:each) do
    assign(:color, color)
  end

  it "renders new color form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => colors_path, :method => "post" do
      assert_select "input#color_name", :name => "color[name]"
      assert_select "input#color_value", :name => "color[value]"
    end
  end
end
