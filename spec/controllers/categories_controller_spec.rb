require 'spec_helper'

describe CategoriesController do

  let(:valid_attributes) { attributes_for(:category) }
  let(:category) { create(:category) }

  describe "unauthorized user" do
    describe "GET index" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :index }
      end
    end

    describe "GET show" do
      it "assigns the requested category as @category" do
        product = create(:product, category: category)
        get :show, {:slug => category.slug}
        assigns(:products).should eq([product])
      end
    end

    describe "GET new" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :new }
      end
    end

    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit, {:slug => category.slug} }
      end
    end

    describe "POST create" do
      it_should_behave_like "access_denied" do
        subject(:connect) { post :create, {:category => valid_attributes} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:slug => category.slug, :category => valid_attributes} }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "access_denied" do
        subject(:connect) { delete :destroy, {:slug => category.slug} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "GET index" do
      it "assigns all categories as @categories" do
        category # create category
        get :index
        assigns(:categories).should eq([category])
      end
    end

    describe "GET new" do
      it "assigns a new category as @category" do
        get :new
        assigns(:category).should be_a_new(Category)
      end
    end

    describe "GET edit" do
      it "assigns the requested category as @category" do
        get :edit, {:slug => category.slug}
        assigns(:category).should eq(category)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Category" do
          expect {
            post :create, {:category => valid_attributes}
          }.to change(Category, :count).by(1)
        end

        it "assigns a newly created category as @category" do
          post :create, {:category => valid_attributes}
          assigns(:category).should be_a(Category)
          assigns(:category).should be_persisted
        end

        it "redirects to the created category" do
          post :create, {:category => valid_attributes}
          response.should redirect_to(Category.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved category as @category" do
          # Trigger the behavior that occurs when invalid params are submitted
          Category.any_instance.stub(:save).and_return(false)
          post :create, {:category => { "name" => "invalid value" }}
          assigns(:category).should be_a_new(Category)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Category.any_instance.stub(:save).and_return(false)
          post :create, {:category => { "name" => "invalid value" }}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested category" do
          Category.any_instance.should_receive(:update_attributes).with({ "name" => "valid value" })
          put :update, {:slug => category.slug, :category => { "name" => "valid value" }}
        end

        it "assigns the requested category as @category" do
          put :update, {:slug => category.slug, :category => valid_attributes}
          assigns(:category).should eq(category)
        end

        it "redirects to the category" do
          put :update, {:slug => category.slug, :category => valid_attributes}
          response.should redirect_to(category)
        end
      end

      describe "with invalid params" do
        it "assigns the category as @category" do
          # Trigger the behavior that occurs when invalid params are submitted
          Category.any_instance.stub(:save).and_return(false)
          put :update, {:slug => category.slug, :category => { "name" => "invalid value" }}
          assigns(:category).should eq(category)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Category.any_instance.stub(:save).and_return(false)
          put :update, {:slug => category.slug, :category => { "name" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      describe "category without products" do
        it "destroys the requested category" do
          category # create category
          expect {
            delete :destroy, {:slug => category.slug}
          }.to change(Category, :count).by(-1)
        end

        it "redirects to the control panel" do
          delete :destroy, {:slug => category.slug}
          response.should redirect_to(control_panel_url)
        end
      end

      describe "category with products" do
        let(:product) { create(:product) }

        it "cannot be destroyed" do
          category = product.category
          expect {
            delete :destroy, {:slug => category.slug}
          }.to change(Category, :count).by(0)
        end

        it "redirects to the category page with alert flash message" do
          category = product.category
          delete :destroy, {:slug => category.slug}
          response.should redirect_to(category)
          flash[:alert].should_not be_nil
        end
      end
    end
  end

end
