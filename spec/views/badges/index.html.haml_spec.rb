require 'spec_helper'

describe "badges/index" do
  let(:badge) { stub_model(Badge, attributes_for(:badge)) }

  before(:each) do
    assign(:badges, [badge, badge])
  end

  it "renders a list of badges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => badge.name.to_s, :count => 2
  end
end
