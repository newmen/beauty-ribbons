require 'spec_helper'

describe CurrentUsersController do

  let(:valid_attributes) { attributes_for(:logged_user) }
  let(:invalid_attributes) { attributes_for(:logged_user, current_password: 'invalid') }
  let(:user) { create(:user) }

  describe "unauthorized user" do
    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:user => valid_attributes} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in user }

    describe "GET edit" do
      it "assigns the current user as @user" do
        get :edit, {:id => user.to_param}
        assigns(:user).should eq(user)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "assigns the current user as @user" do
          put :update, {:user => valid_attributes}
          assigns(:user).should eq(user)
        end

        it "redirects to the control panel" do
          put :update, {:user => valid_attributes}
          response.should redirect_to(control_panel_url)
        end
      end

      describe "with invalid params" do
        it "assigns the current user as @user" do
          put :update, {:user => invalid_attributes}
          assigns(:user).should eq(user)
        end

        it "re-renders the 'edit' template" do
          put :update, {:user => invalid_attributes}
          response.should render_template("edit")
        end
      end
    end
  end

end
