require 'spec_helper'

describe "sitemap/index.xml.haml" do
  let(:category) { create(:category) }
  let(:products) { 3.times.map { |i| create(:product, category: category, name: "product ##{i}") } }

  before(:each) do
    assign(:static_paths, [root_url])
    assign(:category_paths, [category.slug])
    assign(:products, products)
  end

  it 'have links to root, categories and products' do
    render
    assert_select 'urlset[xmlns]' do
      assert_select 'url > loc', text: root_url
      assert_select 'url > loc', text: URI.join(root_url, category.slug).to_s
      products.each do |product|
        assert_select 'url > loc', text: url_for([product.category, product])
      end
    end
  end

end
