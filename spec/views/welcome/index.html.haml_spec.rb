require 'spec_helper'

describe "welcome/index.html.haml" do
  let(:category) { create(:category) }
  let(:page) { create(:welcome_page) }
  let(:products_num) { 3 }

  before(:each) do
    assign(:page, page)
    assign(:products, products_num.times.map { create(:product, category: category) })
  end

  it 'have a page title' do
    render
    assert_select 'h2', text: page.title
  end

  it "have some products" do
    render
    assert_select '.thumbnails' do
      assert_select '.thumbnail.product', count: products_num
    end
  end

  it_behaves_like 'see_or_not_edit_button'
end
