require 'spec_helper'

describe "badges/new" do
  let(:badge) { build(:badge) }
  before(:each) do
    assign(:badge, badge)
  end

  it "renders new badge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => badges_path, :method => "post" do
      assert_select "input#badge_name", :name => "badge[name]"
      assert_select "input#badge_color", :name => "badge[color]"
      assert_select "input#badge_position", :name => "badge[position]"
    end
  end
end
