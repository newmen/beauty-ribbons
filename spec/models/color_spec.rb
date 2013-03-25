require 'spec_helper'

describe Color do
  it { should validate_presence_of(:name) }
  # it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:value) }
  # it { should validate_uniqueness_of(:value) }

  it_should_behave_like "validate_uniqueness", :name
  it_should_behave_like "validate_uniqueness", :value
  it_should_behave_like "colorable", :value
end
