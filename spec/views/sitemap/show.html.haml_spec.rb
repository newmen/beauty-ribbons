require 'spec_helper'

describe "sitemap/show.html.haml" do
  let(:delivery_page) { create(:delivery_page) }
  let(:category) { create(:category) }
  let(:products) { 3.times.map { |i| create(:product, category: category, name: "product ##{i}") } }

  before(:each) do
    assign(:delivery_page, delivery_page)
    assign(:categories, [category])
    assign(:product_static_scopes, Product::STATIC_SCOPES)
    assign(:products, products)
  end

  it 'have each link' do
    render

    assert_select 'p.title', count: 3
    assert_select 'p a', text: I18n.t('welcome.index.title')
    assert_select 'p a', text: delivery_page.title
    assert_select 'p a', text: category.name
    Product::STATIC_SCOPES.each do |scope_name|
      assert_select 'p a', text: I18n.t("static_products.#{scope_name}")
    end
    products.each do |product|
      assert_select 'p a', text: product.name
    end
  end

end
