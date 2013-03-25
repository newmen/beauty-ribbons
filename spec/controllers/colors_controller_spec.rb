require 'spec_helper'

describe ColorsController do

  let(:valid_attributes) { attributes_for(:color) }
  let(:color) { create(:color) }

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
        subject(:connect) { get :edit, {:id => color.to_param} }
      end
    end

    describe "POST create" do
      it_should_behave_like "access_denied" do
        subject(:connect) { post :create, {:color => valid_attributes} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:id => color.to_param, :color => valid_attributes} }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "access_denied" do
        subject(:connect) { delete :destroy, {:id => color.to_param} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

      describe "GET index" do
      it "assigns all colors as @colors" do
        color # create color
        get :index
        assigns(:colors).should eq([color])
      end
    end
  
    describe "GET new" do
      it "assigns a new color as @color" do
        get :new
        assigns(:color).should be_a_new(Color)
      end
    end

    describe "GET edit" do
      it "assigns the requested color as @color" do
        get :edit, {:id => color.to_param}
        assigns(:color).should eq(color)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Color" do
          expect {
            post :create, {:color => valid_attributes}
          }.to change(Color, :count).by(1)
        end

        it "assigns a newly created color as @color" do
          post :create, {:color => valid_attributes}
          assigns(:color).should be_a(Color)
          assigns(:color).should be_persisted
        end

        it "redirects to the colors list" do
          post :create, {:color => valid_attributes}
          response.should redirect_to(colors_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved color as @color" do
          # Trigger the behavior that occurs when invalid params are submitted
          Color.any_instance.stub(:save).and_return(false)
          post :create, {:color => { "name" => "invalid value" }}
          assigns(:color).should be_a_new(Color)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Color.any_instance.stub(:save).and_return(false)
          post :create, {:color => { "name" => "invalid value" }}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested color" do
          Color.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
          put :update, {:id => color.to_param, :color => { "name" => "MyString" }}
        end

        it "assigns the requested color as @color" do
          put :update, {:id => color.to_param, :color => valid_attributes}
          assigns(:color).should eq(color)
        end

        it "redirects to the colors list" do
          put :update, {:id => color.to_param, :color => valid_attributes}
          response.should redirect_to(colors_url)
        end
      end

      describe "with invalid params" do
        it "assigns the color as @color" do
          # Trigger the behavior that occurs when invalid params are submitted
          Color.any_instance.stub(:save).and_return(false)
          put :update, {:id => color.to_param, :color => { "name" => "invalid value" }}
          assigns(:color).should eq(color)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Color.any_instance.stub(:save).and_return(false)
          put :update, {:id => color.to_param, :color => { "name" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested color" do
        color # create color
        expect {
          delete :destroy, {:id => color.to_param}
        }.to change(Color, :count).by(-1)
      end

      it "redirects to the colors list" do
        delete :destroy, {:id => color.to_param}
        response.should redirect_to(colors_url)
      end
    end
  end

end
