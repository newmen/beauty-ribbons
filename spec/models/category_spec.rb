require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }
  # it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:position) }
  it { should validate_numericality_of(:position) }

  it_should_behave_like "validate_uniqueness", :name
end
