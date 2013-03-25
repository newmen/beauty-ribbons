require 'spec_helper'

describe "categories/edit" do
  let(:category) { create(:category) }
  before(:each) do
    assign(:category, category)
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => categories_path(category), :method => "post" do
      assert_select "input#category_name", :name => "category[name]"
      assert_select "input#category_position", :name => "category[position]"
    end
  end
end
