require 'spec_helper'

describe BadgesHelper do
  describe '#badge_label' do
    subject { helper.badge_label(product) }

    describe 'for product with badge' do
      let(:product) { create(:badged_product) }

      it 'DOM containing badge' do
        should have_selector 'div.badge-wrapper'
        should have_selector 'div.special-badge'
        should match product.badge.name
      end
    end

    describe 'for product without badge' do
      let(:product) { create(:product) }

      it 'returns nil' do
        should be_nil
      end
    end
  end
end
