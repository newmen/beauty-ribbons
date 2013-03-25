require 'spec_helper'

describe MenuHelper do
  shared_examples 'menu' do
    it "contain main elements" do
      should have_selector 'nav' do |nav|
        nav.should have_selector 'ul' do |list|
          list.should have_selector 'li'
        end
      end
    end
  end

  describe 'all pages menus' do
    let(:category) { create(:category) }
    let(:delivery_page) { create(:delivery_page) }

    before(:each) do
      category
      delivery_page
    end

    describe '#main_menu' do
      subject { helper.main_menu }

      it_should_behave_like 'menu'

      it "contain categories and delivery link" do
        should match category.name
        should match delivery_page.title
      end
    end

    describe '#bottom_menu' do
      subject { helper.bottom_menu }

      it_should_behave_like 'menu'

      it "contain categories and delivery link" do
        should match category.name
        should match delivery_page.title
      end

      it "contain sign in link" do
        should match I18n.t('devise.shared_links.sign_in')
      end

      it "contain admin links when user signed in" do
        sign_in create(:user)

        should match I18n.t('control_panel.index.title')
        should match I18n.t('devise.shared_links.sign_out')
      end
    end
  end
end
