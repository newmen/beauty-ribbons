require 'spec_helper'

describe OrderController do
  shared_examples "change_order_state" do
    describe "unauthorized user" do
      describe "PUT 'update'" do
        it_should_behave_like "unauthorized_explained" do
          subject(:connect) { put :update, id: order.to_param, state: order.state, format: :js }
        end
      end

      describe "DELETE 'destroy'" do
        it_should_behave_like "unauthorized_explained" do
          subject(:connect) { delete :destroy, id: order.to_param, format: :js }
        end
      end
    end

    describe "authorized user" do
      before(:each) { sign_in create(:user) }

      describe "PUT 'update'" do
        it "returns http success" do
          put :update, id: order.to_param, state: order.state, format: :js
          response.should be_success
        end

        it "returns http bad request" do
          put :update, id: order.to_param, state: 'incorrect', format: :js
          response.response_code.should eq(400)
        end

        it "assigns the requested order as @order" do
          put :update, id: order.to_param, state: order.state, format: :js
          assigns(:order).should eq(order)
        end

        it "state of requested order switched to next" do
          put :update, id: order.to_param, state: order.state, format: :js
          assigns(:order).state.should eq(order.next_state)
        end
      end

      describe "DELETE 'destroy'" do
        it "returns http success" do
          delete :destroy, id: order.to_param, format: :js
          response.should be_success
        end

        it "assigns the requested order as @order" do
          delete :destroy, id: order.to_param, format: :js
          assigns(:order).should eq(order)
        end

        it "state of requested order is canceled" do
          delete :destroy, id: order.to_param, format: :js
          assigns(:order).state.should eq('canceled')
        end
      end
    end
  end

  describe 'PostalOrder' do
    it_behaves_like 'change_order_state' do
      let(:order) { create(:postal_order) }
    end
  end

  describe 'PreOrder' do
    it_behaves_like 'change_order_state' do
      let(:order) { create(:pre_order) }
    end
  end
end
