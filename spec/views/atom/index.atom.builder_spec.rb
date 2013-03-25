require 'spec_helper'

describe "atom/index.atom.builder" do
  let(:products_num) { 3 }
  let(:category) { create(:category) }
  let(:products) { products_num.times.map { |i| create(:product, category: category, name: "product ##{i}") } }

  before(:each) do
    assign(:products, products)
  end

  it 'have general tags' do
    render
    assert_select 'feed' do
      assert_select 'title'
      assert_select 'updated'
      assert_select 'entry', count: products_num do
        assert_select 'published'
        assert_select 'updated'
        assert_select 'link'
        assert_select 'title'
        assert_select 'content'
      end
    end
  end
end
