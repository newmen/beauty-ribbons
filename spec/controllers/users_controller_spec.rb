require 'spec_helper'

describe UsersController do

  let(:valid_attributes) { attributes_for(:admin, email: 'temp@temp.ru') }
  let(:user) { create(:admin) }

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
        subject(:connect) { get :edit, {:id => user.to_param} }
      end
    end

    describe "POST create" do
      it_should_behave_like "access_denied" do
        subject(:connect) { post :create, {:user => valid_attributes} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:id => user.to_param, :user => valid_attributes} }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "access_denied" do
        subject(:connect) { delete :destroy, {:id => user.to_param} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in user }

    describe "GET index" do
      it "assigns all users as @users" do
        user # create user
        get :index
        assigns(:users).should eq([user])
      end
    end
  
    describe "GET new" do
      it "assigns a new user as @user" do
        get :new
        assigns(:user).should be_a_new(User)
      end
    end

    describe "GET edit" do
      it "assigns the requested user as @user" do
        get :edit, {:id => user.to_param}
        assigns(:user).should eq(user)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new User" do
          expect {
            post :create, {:user => valid_attributes}
          }.to change(User, :count).by(1)
        end

        it "assigns a newly created user as @user" do
          post :create, {:user => valid_attributes}
          assigns(:user).should be_a(User)
          assigns(:user).should be_persisted
        end

        it "redirects to the users list" do
          post :create, {:user => valid_attributes}
          response.should redirect_to(users_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved user as @user" do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          post :create, {:user => {}}
          assigns(:user).should be_a_new(User)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          post :create, {:user => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested user" do
          User.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
          put :update, {:id => user.to_param, :user => { "these" => "params" }}
        end

        it "assigns the requested user as @user" do
          put :update, {:id => user.to_param, :user => valid_attributes}
          assigns(:user).should eq(user)
        end

        it "redirects to the users list" do
          put :update, {:id => user.to_param, :user => valid_attributes}
          response.should redirect_to(users_url)
        end
      end

      describe "with invalid params" do
        it "assigns the user as @user" do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          put :update, {:id => user.to_param, :user => {}}
          assigns(:user).should eq(user)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          User.any_instance.stub(:save).and_return(false)
          put :update, {:id => user.to_param, :user => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested user" do
        user # create user
        expect {
          delete :destroy, {:id => user.to_param}
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, {:id => user.to_param}
        response.should redirect_to(users_url)
      end
    end
  end

end
