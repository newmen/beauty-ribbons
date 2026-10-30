require 'spec_helper'

describe Tag do
  subject { build(:tag) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  # it_should_behave_like "validate_uniqueness", :name
end
