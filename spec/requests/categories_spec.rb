require 'spec_helper'

describe "Categories", type: :request do
  let!(:delivery_page) { create(:delivery_page) }
  let(:category) { create(:category) }
  let(:tag) { create(:tag) }
  let(:product) do
    create(:product, category: category).tap do |product|
      product.tags << tag
    end
  end

  it "renders the category page with the filter form" do
    product

    get category_path(category)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(I18n.t("categories.show.filter.title"))
  end

  it "renders the category page with filter parameters" do
    product

    get category_path(category), params: { tags: tag.id.to_s }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(tag.name)
  end
end
