require 'spec_helper'

describe PageImage do
  it { should validate_presence_of(:image) }
end
