require 'spec_helper'

describe Page do
  it { should validate_presence_of(:title) }
  # it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:markdown) }

  it_should_behave_like "validate_uniqueness", :title
end
