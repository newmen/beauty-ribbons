require 'spec_helper'

describe PostalOrdersController do

  let(:valid_attributes) { attributes_for(:postal_order) }
  let(:postal_order) { create(:postal_order) }
  let(:product) { create(:product) }
  let(:archived_product) { create(:archived_product) }

  subject(:store_product) { controller.stored_product_ids << product.id }
  subject(:store_archived_product) { controller.stored_product_ids << archived_product.id }

  describe "unauthorized user" do
    describe "GET index" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :index }
      end
    end

    describe "GET new" do
      it "redirects if no stored products" do
        get :new
        response.should be_redirect
        flash[:alert].should_not be_nil
      end

      it "redirects if stored product is archived" do
        store_archived_product
        get :new
        response.should be_redirect
        flash[:alert].should_not be_nil
      end

      describe "has stored product" do
        before(:each) { store_product }

        it "returns http success if has stored product" do
          get :new
          response.should be_success
        end

        it "assigns a new postal_order as @postal_order" do
          get :new
          assigns(:postal_order).should be_a_new(PostalOrder)
        end
      end
    end

    describe "POST create" do
      describe "has a stored product" do
        before(:each) { store_product }

        describe "ordered product list was changed" do
          it "re-renders form with alert flash message" do
            post :create, postal_order: valid_attributes, ordered_products: []
            response.should render_template("new")
            flash[:alert].should_not be_nil
          end
        end

        describe "with valid params" do
          it "creates a new PostalOrder" do
            expect {
              post :create, postal_order: valid_attributes, ordered_products: [product.id.to_s]
            }.to change(PostalOrder, :count).by(1)
          end

          it "assigns a newly created postal_order as @postal_order" do
            post :create, postal_order: valid_attributes, ordered_products: [product.id.to_s]
            assigns(:postal_order).should be_a(PostalOrder)
            assigns(:postal_order).should be_persisted
          end

          it "redirects to welcome page" do
            post :create, postal_order: valid_attributes, ordered_products: [product.id.to_s]
            response.should redirect_to(root_url)
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved postal_order as @postal_order" do
            # Trigger the behavior that occurs when invalid params are submitted
            PostalOrder.any_instance.stub(:save).and_return(false)
            post :create, postal_order: { "username" => "invalid value" }, ordered_products: [product.id.to_s]
            assigns(:postal_order).should be_a_new(PostalOrder)
          end

          it "re-renders the 'new' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            PostalOrder.any_instance.stub(:save).and_return(false)
            post :create, postal_order: { "username" => "invalid value" }, ordered_products: [product.id.to_s]
            response.should render_template("new")
          end
        end
      end

      describe "havent a stored product" do
        it "redirects to cart page with alert message" do
          post :create, postal_order: valid_attributes, ordered_products: [product.id.to_s]
          response.should redirect_to(cart_url)
          flash[:alert].should_not be_nil
        end
      end
    end

    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit, {:id => postal_order.to_param} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:id => postal_order.to_param, :postal_order => valid_attributes} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "GET index" do
      it "assigns all postal_orders as @postal_orders" do
        postal_order # create postal_order
        get :index
        assigns(:postal_orders).should eq([postal_order])
      end
    end

    describe "GET edit" do
      it "assigns the requested postal_order as @postal_order" do
        get :edit, {:id => postal_order.to_param}
        assigns(:postal_order).should eq(postal_order)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested postal_order" do
          PostalOrder.any_instance.should_receive(:update_attributes).with({ "username" => "valid value" })
          put :update, {:id => postal_order.to_param, :postal_order => { "username" => "valid value" }}
        end

        it "assigns the requested postal_order as @postal_order" do
          put :update, {:id => postal_order.to_param, :postal_order => valid_attributes}
          assigns(:postal_order).should eq(postal_order)
        end

        it "redirects to the postal_order" do
          put :update, {:id => postal_order.to_param, :postal_order => valid_attributes}
          response.should redirect_to(postal_orders_url)
        end
      end

      describe "with invalid params" do
        it "assigns the postal_order as @postal_order" do
          # Trigger the behavior that occurs when invalid params are submitted
          PostalOrder.any_instance.stub(:save).and_return(false)
          put :update, {:id => postal_order.to_param, :postal_order => { "username" => "invalid value" }}
          assigns(:postal_order).should eq(postal_order)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          PostalOrder.any_instance.stub(:save).and_return(false)
          put :update, {:id => postal_order.to_param, :postal_order => { "username" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end
  end

end
