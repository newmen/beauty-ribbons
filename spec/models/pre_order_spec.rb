require 'spec_helper'

describe PreOrder do
  extend OrderExamples

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }

  it_should_behave_like "emailable", :email

  describe "complex behavior" do
    let(:order) { create(:pre_order) }

    it_should_behave_like "associated_with_products"
    it_should_behave_like "sequenced_states"
  end
end
