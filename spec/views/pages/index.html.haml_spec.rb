require 'spec_helper'

describe "pages/index" do
  let(:page) { stub_model(Category, attributes_for(:page)) }

  before(:each) do
    assign(:pages, [page, page])
  end

  it "renders a list of pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => page.title.to_s, :count => 2
  end
end
