require 'spec_helper'

describe "users/index" do
  let(:user) { stub_model(User, attributes_for(:user)) }

  before(:each) do
    assign(:users, [user, user])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => user.email.to_s, :count => 2
  end
end
