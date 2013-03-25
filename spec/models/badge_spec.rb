require 'spec_helper'

describe Badge do
  it { should validate_presence_of(:name) }
  # it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:color) }
  it { should validate_presence_of(:position) }
  it { should validate_numericality_of(:position) }

  it_should_behave_like "colorable", :color
  it_should_behave_like "validate_uniqueness", :name
end
