require 'spec_helper'

describe ApplicationHelper do
  describe 'meta tags' do
    shared_examples 'meta_tag' do |helper_name|
      it { Capybara.string(helper.send(helper_name)).has_selector? 'meta' }
    end

    it_should_behave_like 'meta_tag', :encoding_meta_tag
    it_should_behave_like 'meta_tag', :device_meta_tag
  end

  describe 'title helper methods' do
    let(:title_text) { 'Extended title' }

    describe '#title' do
      it 'display titled text' do
        helper.title(title_text).should have_selector 'h2', text: title_text
      end
    end

    describe '#title_tag' do
      subject { Capybara.string(helper.title_tag) }

      it 'display title tag with default title' do
        subject.has_selector? 'title', text: I18n.t('default_title')
      end

      it 'display title tag with extended title' do
        helper.title(title_text)
        subject.has_selector? 'title' do |content|
          content.should contain title_text
          content.should contain I18n.t('default_title')
        end
      end
    end

    describe '#title_with_edit_button' do
      subject { helper.title_with_edit_button(title_text, '/') }

      it 'unauthorized user sees only title' do
        should have_selector 'h2', text: title_text
      end

      it 'authorized user sees title and edit button' do
        sign_in create(:user)
        should match /front-actions/
        should have_edit_button
        should have_selector 'h2', text: title_text
      end
    end
  end

  describe '#url_helper_value' do
    it 'cut and get valid value' do
      helper.url_helper_value('/path_to').should eq "#{root_url}path_to"
    end
  end

  describe '#hidden_tag_unless' do
    describe 'hidden tag' do
      it { helper.hidden_tag_unless(:div, false).should have_selector 'div', visible: false }
    end

    describe 'shown tag' do
      let(:content) { 'shown content' }
      subject { helper.hidden_tag_unless(:div, true) { content } }

      it { should have_selector 'div', visible: true }
      it { should match content }
    end
  end

  describe '#alert_tag' do
    describe 'hidden alert tag' do
      it { helper.alert_tag(false).should be_nil }
    end

    describe 'shown alert tag' do
      let(:content) { 'alert message' }
      subject { helper.alert_tag(content) }

      it { should_not match 'display: none' }
      it { should match content }
      it { should match '&times;' }
    end
  end

  describe '#append_icon' do
    let(:text) { 'iconized text' }
    subject { helper.append_icon(text, 'icon-class') }

    it 'icon with text' do
      should have_selector 'i[class]'
      should match text
    end
  end

  describe 'standart action buttons' do
    it '#add_button' do
      model_name = Color # for example
      helper.add_button(model_name, '/').should have_add_button(model_name)
    end

    it '#show_button' do
      helper.show_button('/').should have_show_button
    end

    it '#edit_button' do
      helper.edit_button('/').should have_edit_button
    end

    it '#delete_button' do
      helper.delete_button('/').should have_destroy_button
    end

    it '#cancel_button' do
      helper.cancel_button.should have_go_back_button
    end
  end

end
