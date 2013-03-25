require 'spec_helper'

describe "users/new" do
  let(:user) { build(:user) }
  before(:each) do
    assign(:user, user)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_password", :name => "user[password]"
    end
  end
end
