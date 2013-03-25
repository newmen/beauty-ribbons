require 'spec_helper'

describe ColorsHelper do
  let(:color_value) { 'ffff00' }

  describe '#color_box' do
    describe 'default behavior' do
      subject { helper.color_box(color_value) }

      it 'returns a div with color-box class and gradient style' do
        should have_selector 'div.color-box[style*="gradient"]'
        should match color_value
      end

      it 'box is not checked' do
        should have_selector '.color-box'
      end
    end

    describe 'no default behavior' do
      it 'box is checked' do
        helper.color_box(color_value, true).should have_selector '.color-box.checked'
      end
    end
  end

  describe '#gradient' do
    subject { helper.gradient('top', color_value) }

    it 'returns a style string contains background settings' do
      should match 'background-color:'
      should match 'background-image:'
      ['-webkit-', '-moz-', '-o-', ''].each do |prefix|
        should match "#{prefix}linear-gradient"
      end
    end
  end

  describe 'sass helpers' do
    it 'darken deligate' do
      helper.darken(color_value, 10).should eq '#cccc00'
    end

    it 'lighten deligate' do
      helper.lighten(color_value, 30).should eq '#ffff99'
    end
  end
end
