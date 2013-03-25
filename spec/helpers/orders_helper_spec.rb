require 'spec_helper'

describe OrdersHelper do
  shared_examples 'any_order_helpers' do
    describe '#order_state' do
      let(:not_cancel_link_selector) { 'a.dynamic-order' }

      it "state is confirmed" do
        helper.order_state(order).should have_selector not_cancel_link_selector
      end

      it "state is processing" do
        order.state = 'processing'
        helper.order_state(order).should have_selector not_cancel_link_selector
      end

      it "state is completed" do
        order.state = 'completed'
        helper.order_state(order).should_not have_selector not_cancel_link_selector
      end

      it "state is canceled" do
        order.state = 'canceled'
        helper.order_state(order).should_not have_selector not_cancel_link_selector
      end
    end
  end

  describe 'PostalOrder' do
    it_behaves_like 'any_order_helpers' do
      let(:order) { create(:postal_order) }
    end
  end

  describe 'PreOrder' do
    it_behaves_like 'any_order_helpers' do
      let(:order) { create(:pre_order) }
    end
  end

  describe '#form_row' do
    let(:label_text) { 'label_text' }
    let(:value_text) { 'value_text' }
    let(:row_css_class) { 'row_css_class' }

    shared_examples 'form_row' do
      it do
        should have_selector(".control-group.#{row_css_class}") do |content|
          content.should have_selector 'label', text: label_text
          content.should have_selector '.controls.with_text' do |controls|
            controls.should have_text value_text
          end
        end
      end
    end

    describe 'without block' do
      subject { helper.form_row(label_text, value_text, row_css_class) }
      it_behaves_like 'form_row'
    end

    describe 'with block' do
      subject { helper.form_row(label_text, row_css_class) { value_text } }
      it_behaves_like 'form_row'
    end
  end
end
