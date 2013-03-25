require 'spec_helper'

describe "categories/show" do
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  before(:each) do
    view.stub(:params).and_return({ 'controller' => 'categories', 'action' => 'show', 'slug' => category.slug })
    assign(:category, category)
    assign(:products, Product.scoped)
    assign(:all_products, Product.scoped)
  end

  it "renders products" do
    product # create product
    render

    rendered.should match product.name.to_s
  end

  it "renders nothing to show message and not show filter by tags and colors" do
    render

    rendered.should match I18n.t('categories.show.nothing_to_show')
    rendered.should_not match I18n.t('categories.show.filter.tags')
    rendered.should_not match I18n.t('categories.show.filter.colors')
  end

  it "show all filter elements" do
    product.tags << create(:tag)
    product.colors << create(:color)
    render

    rendered.should match I18n.t('categories.show.filter.title')
    rendered.should match I18n.t('categories.show.filter.tags')
    rendered.should match I18n.t('categories.show.filter.colors')
    rendered.should match I18n.t('categories.show.filter.prices')
  end

  it_behaves_like 'see_or_not_add_button', Product
end
