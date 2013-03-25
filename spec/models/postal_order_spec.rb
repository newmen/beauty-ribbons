# coding: utf-8

require 'spec_helper'

describe PostalOrder do
  extend OrderExamples

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:zipcode) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:street_line) }
  it { should validate_presence_of(:amount) }

  it_should_behave_like "emailable", :email

  describe "complex behavior" do
    let(:order) { create(:postal_order) }

    it_should_behave_like "associated_with_products"
    it_should_behave_like "sequenced_states"
  end
end
