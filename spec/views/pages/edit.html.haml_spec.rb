require 'spec_helper'

describe "pages/edit" do
  let(:page) { create(:page) }
  before(:each) do
    assign(:page, page)
  end

  it "renders the edit page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :method => "post" do
      assert_select "input#page_title", :name => "page[title]"
      assert_select "textarea#page_markdown", :name => "page[markdown]"
    end
  end
end
