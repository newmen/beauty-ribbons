require 'spec_helper'

describe "pages/show" do
  let(:page) { create(:page) }
  before(:each) do
    assign(:page, page)
  end

  it "renders page" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match page.title.to_s
    rendered.should match page.html.to_s
  end

  it_behaves_like 'see_or_not_edit_button'
end
