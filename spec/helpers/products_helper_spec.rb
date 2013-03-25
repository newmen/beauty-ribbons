require 'spec_helper'

describe ProductsHelper do
  let(:color) { create(:color) }
  let(:tag) { create(:tag) }
  let(:product) do
    p = create(:product)
    p.colors << color
    p.tags << tag
    p
  end

  before(:each) do
    helper.stub!(:params).and_return({ 'controller' => 'products', 'action' => 'index' })
  end

  describe '#filter_title' do
    %w(tags colors prices).each do |filter_name|
      it "return #{filter_name} title wrapped to h6" do
        helper.filter_title(filter_name).should have_selector 'h6', text: I18n.t("categories.show.filter.#{filter_name}")
      end
    end
  end

  describe '#common_tags_list' do
    subject { helper.common_tags_list([product]) }

    it 'returns wrapped tags list' do
      should have_selector 'div.tags' do |content|
        content.should have_selector 'h6', text: t('categories.show.filter.tags')
        content.should have_selector 'ul'
      end
    end

    it 'each tag is a link wrapped of list item' do
      should have_selector 'li a', text: tag.name
    end

    it 'checked tag has correspond css class and remove itself from params' do
      helper.params.merge!('tags' => tag.id.to_s)
      should have_selector 'li.checked a'
      should_not match /tags=/
    end
  end

  describe '#common_colors_list' do
    subject { helper.common_colors_list([product]) }

    it 'returns wrapped colors list' do
      should have_selector 'div.colors' do |content|
        content.should have_selector 'h6', text: t('categories.show.filter.colors')
        content.should have_selector 'div.colors-list'
      end
    end

    it 'each color is a link that contain div with color-box css class' do
      should have_selector 'a div.color-box'
    end

    it 'checked color has correspond css class and remove itself from params' do
      helper.params.merge!('colors' => color.id.to_s)
      should have_selector 'div.color-box.checked[style]'
      should_not match /colors=/
    end
  end

  describe '#price_form' do
    subject { helper.price_form(Product.scoped) }

    let(:min_price) { product.price.to_f.to_i }
    let(:max_price) { another_product.price.to_f.to_i }
    let(:another_product) do
      create(:product, name: 'another product', category: product.category, price_cents: product.price_cents * 2)
    end

    before(:each) do
      product
      another_product
    end

    it 'returns a form' do
      should have_selector 'form'
    end

    %w(min max).each do |agr|
      it "contain #{agr} price value" do
        should have_selector %(input[name="#{agr}_price"][value="#{send("#{agr}_price")}"])
      end
    end
  end

  describe '#cancel_filter_link' do
    subject { helper.cancel_filter_link }

    it 'nothing to return' do
      should be_nil
    end

    it 'returns a cancel link wrapped to div' do
      helper.params.merge!('tags' => tag.id.to_s)
      should have_selector 'div.cancel' do |content|
        content.should have_selector 'a[href]', text: I18n.t('categories.show.filter.cancel')
      end
    end
  end

  describe '#sorting_links' do
    subject { helper.sorting_links }

    Settings.sorting.fields.each do |sort_name|
      it "contain #{sort_name} link" do
        should have_selector %(a[href*="sort_by=#{sort_name}"]), text: I18n.t("categories.show.sorting.#{sort_name}") do |link|
          link.should have_selector 'i[class]'
        end
      end
    end

    it 'default sorting link not contain sort_by param' do
      default_sort_name, direct = Settings.sorting.default.split('-')
      rdirect = direct == 'asc' ? 'desc' : 'asc'
      helper.params.merge!('sort_by' => "#{default_sort_name}-#{rdirect}")
      should_not have_selector 'a[href*="sort_by="]', text: I18n.t("categories.show.sorting.#{default_sort_name}") do |link|
        link.should have_selector 'i[class]'
      end
    end
  end
end

