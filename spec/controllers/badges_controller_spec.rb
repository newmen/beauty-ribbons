require 'spec_helper'

describe BadgesController do

  let(:valid_attributes) { attributes_for(:badge) }
  let(:badge) { create(:badge) }

  describe "unauthorized user" do
    describe "GET index" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :index }
      end
    end

    describe "GET new" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :new }
      end
    end

    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit, {:id => badge.to_param} }
      end
    end

    describe "POST create" do
      it_should_behave_like "access_denied" do
        subject(:connect) { post :create, {:badge => valid_attributes} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:id => badge.to_param, :badge => valid_attributes} }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "access_denied" do
        subject(:connect) { delete :destroy, {:id => badge.to_param} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "GET index" do
      it "assigns all badges as @badges" do
        badge # create badge
        get :index
        assigns(:badges).should eq([badge])
      end
    end

    describe "GET new" do
      it "assigns a new badge as @badge" do
        get :new
        assigns(:badge).should be_a_new(Badge)
      end
    end

    describe "GET edit" do
      it "assigns the requested badge as @badge" do
        get :edit, {:id => badge.to_param}
        assigns(:badge).should eq(badge)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Badge" do
          expect {
            post :create, {:badge => valid_attributes}
          }.to change(Badge, :count).by(1)
        end

        it "assigns a newly created badge as @badge" do
          post :create, {:badge => valid_attributes}
          assigns(:badge).should be_a(Badge)
          assigns(:badge).should be_persisted
        end

        it "redirects to the badges list" do
          post :create, {:badge => valid_attributes}
          response.should redirect_to(badges_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved badge as @badge" do
          # Trigger the behavior that occurs when invalid params are submitted
          Badge.any_instance.stub(:save).and_return(false)
          post :create, {:badge => { "name" => "invalid value" }}
          assigns(:badge).should be_a_new(Badge)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Badge.any_instance.stub(:save).and_return(false)
          post :create, {:badge => { "name" => "invalid value" }}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested badge" do
          Badge.any_instance.should_receive(:update_attributes).with({ "name" => "valid value" })
          put :update, {:id => badge.to_param, :badge => { "name" => "valid value" }}
        end

        it "assigns the requested badge as @badge" do
          put :update, {:id => badge.to_param, :badge => valid_attributes}
          assigns(:badge).should eq(badge)
        end

        it "redirects to the badges list" do
          put :update, {:id => badge.to_param, :badge => valid_attributes}
          response.should redirect_to(badges_url)
        end
      end

      describe "with invalid params" do
        it "assigns the badge as @badge" do
          # Trigger the behavior that occurs when invalid params are submitted
          Badge.any_instance.stub(:save).and_return(false)
          put :update, {:id => badge.to_param, :badge => { "name" => "invalid value" }}
          assigns(:badge).should eq(badge)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Badge.any_instance.stub(:save).and_return(false)
          put :update, {:id => badge.to_param, :badge => { "name" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested badge" do
        badge # create badge
        expect {
          delete :destroy, {:id => badge.to_param}
        }.to change(Badge, :count).by(-1)
      end

      it "redirects to the badges list" do
        delete :destroy, {:id => badge.to_param}
        response.should redirect_to(badges_url)
      end
    end
  end

end
