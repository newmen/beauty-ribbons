require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it "validates email uniqueness case-insensitively" do
    create(:user, email: "taken@example.com")
    user = build(:user, email: "TAKEN@example.com")
    user.valid?
    expect(user.errors[:email]).not_to be_empty
  end

  it_should_behave_like "emailable", :email
end
