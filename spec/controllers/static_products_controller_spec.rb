require 'spec_helper'

describe StaticProductsController do

  let(:product) { create(:product) }

  it "novelties returns specified products" do
    Settings.reload!
    Settings[:nova_days] = '1'

    product # create product
    get :index, novelties: true
    assigns(:products).should eq([product])

    Settings.reload!
  end

  it "sales returns specified products" do
    product = create(:sale_product)
    get :index, sales: true
    assigns(:products).should eq([product])
  end

  it "archived returns specified products" do
    product = create(:archived_product)
    get :index, archived: true
    assigns(:products).should eq([product])
  end

end
