require 'spec_helper'

describe ProductsController do

  let(:product) { create(:product) }
  let(:category) { product.category }
  let(:valid_attributes) do
    attributes = attributes_for(:product).select { |_, v| v }
    current_category = (c = Category.first) ? c : create(:category)
    attributes['category_id'] = current_category.id
    attributes['cover_id'] = create(:product_image).id
    attributes
  end

  describe "unauthorized user" do
    describe "GET index" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :index }
      end
    end

    describe "GET show" do
      it "assigns the requested product as @product" do
        get :show, category_slug: category.slug, slug: product.slug
        assigns(:product).should eq(product)
      end
    end

    describe "GET new" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :new, category_slug: category.slug }
      end
    end

    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit, category_slug: category.slug, slug: product.slug }
      end
    end

    describe "POST create" do
      it_should_behave_like "access_denied" do
        subject(:connect) { post :create, product: valid_attributes }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, id: product.to_param, product: valid_attributes }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "access_denied" do
        subject(:connect) { delete :destroy, category_slug: category.slug, slug: product.slug }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "GET index" do
      it "assigns all products as @products" do
        product # create product
        get :index
        assigns(:products).should eq([product])
      end
    end

    describe "GET new" do
      it "assigns a new product as @product" do
        get :new, category_slug: category.slug
        assigns(:product).should be_a_new(Product)
      end
    end

    describe "GET edit" do
      it "assigns the requested product as @product" do
        get :edit, category_slug: category.slug, slug: product.slug
        assigns(:product).should eq(product)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Product" do
          expect {
            post :create, product: valid_attributes
          }.to change(Product, :count).by(1)
        end

        it "assigns a newly created product as @product" do
          post :create, product: valid_attributes
          assigns(:product).should be_a(Product)
          assigns(:product).should be_persisted
        end

        it "redirects to the created product" do
          post :create, product: valid_attributes
          created_product = Product.last
          response.should redirect_to(url_for([created_product.category, created_product]))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved product as @product" do
          # Trigger the behavior that occurs when invalid params are submitted
          Product.any_instance.stub(:save).and_return(false)
          post :create, :product => { "name" => "invalid value" }
          assigns(:product).should be_a_new(Product)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Product.any_instance.stub(:save).and_return(false)
          post :create, :product => { "name" => "invalid value" }
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested product" do
          Product.any_instance.should_receive(:update_attributes).with({ "name" => "valid value" })
          put :update, id: product.to_param, product: { "name" => "valid value" }
        end

        it "assigns the requested product as @product" do
          put :update, id: product.to_param, product: valid_attributes
          assigns(:product).should eq(product)
        end

        it "redirects to the product" do
          put :update, id: product.to_param, product: valid_attributes
          response.should redirect_to(url_for([category, product]))
        end
      end

      describe "with invalid params" do
        it "assigns the product as @product" do
          # Trigger the behavior that occurs when invalid params are submitted
          Product.any_instance.stub(:save).and_return(false)
          put :update, id: product.to_param, product: { "name" => "invalid value" }
          assigns(:product).should eq(product)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Product.any_instance.stub(:save).and_return(false)
          put :update, id: product.to_param, product: { "name" => "invalid value" }
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested product" do
        product # create product
        expect {
          delete :destroy, category_slug: category.slug, slug: product.slug
        }.to change(Product, :count).by(-1)
      end

      it "redirects to the products list" do
        delete :destroy, category_slug: category.slug, slug: product.slug
        response.should redirect_to(category_url(category))
      end
    end
  end

end
