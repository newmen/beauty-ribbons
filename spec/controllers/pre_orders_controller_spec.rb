require 'spec_helper'

describe PreOrdersController do

  let(:valid_attributes) { attributes_for(:pre_order) }
  let(:pre_order) { create(:pre_order) }
  let(:product) { create(:product) }
  let(:archived_product) { create(:archived_product) }

  subject(:store_product) { controller.send(:stored_product_ids) << product.id }
  subject(:store_archived_product) { controller.send(:stored_product_ids) << archived_product.id }

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

      it "redirects if stored product is not archived" do
        store_product
        get :new
        response.should be_redirect
        flash[:alert].should_not be_nil
      end

      describe "has stored archived product" do
        before(:each) { store_archived_product }

        it "returns http success if has stored product" do
          get :new
          response.should be_success
        end

        it "assigns a new pre_order as @pre_order" do
          get :new
          assigns(:pre_order).should be_a_new(PreOrder)
        end
      end
    end

    describe "POST create" do
      describe "has a stored archived product" do
        before(:each) { store_archived_product }

        describe "with valid params" do
          it "creates a new PreOrder" do
            expect {
              post :create, pre_order: valid_attributes, desired_products: [archived_product.id.to_s]
            }.to change(PreOrder, :count).by(1)
          end

          it "assigns a newly created pre_order as @pre_order" do
            post :create, pre_order: valid_attributes, desired_products: [archived_product.id.to_s]
            assigns(:pre_order).should be_a(PreOrder)
            assigns(:pre_order).should be_persisted
          end

          it "redirects to welcome page" do
            post :create, pre_order: valid_attributes, desired_products: [archived_product.id.to_s]
            response.should redirect_to(root_url)
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved pre_order as @pre_order" do
            # Trigger the behavior that occurs when invalid params are submitted
            PreOrder.any_instance.stub(:save).and_return(false)
            post :create, pre_order: { "username" => "invalid value" }, desired_products: [archived_product.id.to_s]
            assigns(:pre_order).should be_a_new(PreOrder)
          end

          it "re-renders the 'new' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            PreOrder.any_instance.stub(:save).and_return(false)
            post :create, pre_order: { "username" => "invalid value" }, desired_products: [archived_product.id.to_s]
            response.should render_template("new")
          end
        end
      end

      describe "havent a stored archived product" do
        it "redirects to cart page with notice message" do
          post :create, pre_order: valid_attributes, desired_products: [archived_product.id.to_s]
          response.should redirect_to(cart_url)
          flash[:notice].should_not be_nil
        end
      end
    end

    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit, {:id => pre_order.to_param} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:id => pre_order.to_param, :pre_order => valid_attributes} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "GET index" do
      it "assigns all pre_orders as @pre_orders" do
        pre_order # create pre_order
        get :index
        assigns(:pre_orders).should eq([pre_order])
      end
    end

    describe "GET edit" do
      it "assigns the requested pre_order as @pre_order" do
        get :edit, {:id => pre_order.to_param}
        assigns(:pre_order).should eq(pre_order)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested pre_order" do
          PreOrder.any_instance.should_receive(:update_attributes).with({ "username" => "valid value" })
          put :update, {:id => pre_order.to_param, :pre_order => { "username" => "valid value" }}
        end

        it "assigns the requested pre_order as @pre_order" do
          put :update, {:id => pre_order.to_param, :pre_order => valid_attributes}
          assigns(:pre_order).should eq(pre_order)
        end

        it "redirects to the pre_order" do
          put :update, {:id => pre_order.to_param, :pre_order => valid_attributes}
          response.should redirect_to(pre_orders_path)
        end
      end

      describe "with invalid params" do
        it "assigns the pre_order as @pre_order" do
          # Trigger the behavior that occurs when invalid params are submitted
          PreOrder.any_instance.stub(:save).and_return(false)
          put :update, {:id => pre_order.to_param, :pre_order => { "username" => "invalid value" }}
          assigns(:pre_order).should eq(pre_order)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          PreOrder.any_instance.stub(:save).and_return(false)
          put :update, {:id => pre_order.to_param, :pre_order => { "username" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end
  end

end
