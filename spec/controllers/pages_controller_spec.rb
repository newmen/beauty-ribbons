require 'spec_helper'

describe PagesController do

  let(:valid_attributes) { attributes_for(:page) }
  let(:current_page) { create(:page) }

  describe "unauthorized user" do
    describe "GET index" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :index }
      end
    end

    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit, {:id => current_page.to_param} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:id => current_page.to_param, :page => valid_attributes} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

    describe "GET index" do
      it "assigns all pages as @pages" do
        current_page # create page
        get :index
        assigns(:pages).should eq([current_page])
      end
    end

    describe "GET edit" do
      it "assigns the requested page as @page" do
        get :edit, {:id => current_page.to_param}
        assigns(:page).should eq(current_page)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested page" do
          Page.any_instance.should_receive(:update_attributes).with({ "title" => "valid value" })
          put :update, {:id => current_page.to_param, :page => { "title" => "valid value" }}
        end

        it "assigns the requested page as @page" do
          put :update, {:id => current_page.to_param, :page => valid_attributes}
          assigns(:page).should eq(current_page)
        end

        it "redirects to the control panel" do
          put :update, {:id => current_page.to_param, :page => valid_attributes}
          response.should redirect_to(control_panel_url)
        end
      end

      describe "with invalid params" do
        it "assigns the page as @page" do
          # Trigger the behavior that occurs when invalid params are submitted
          Page.any_instance.stub(:save).and_return(false)
          put :update, {:id => current_page.to_param, :page => { "title" => "invalid value" }}
          assigns(:page).should eq(current_page)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Page.any_instance.stub(:save).and_return(false)
          put :update, {:id => current_page.to_param, :page => { "title" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end
  end

end
