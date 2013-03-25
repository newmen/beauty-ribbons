require 'spec_helper'

<% module_namespacing do -%>
describe <%= controller_class_name %>Controller do

  let(:valid_attributes) { attributes_for(:<%= file_name %>) }
  let(:<%= file_name %>) { create(:<%= file_name %>) }

  describe "unauthorized user" do
  <% unless options[:singleton] -%>
    describe "GET index" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :index }
      end
    end
  <% end -%>

    describe "GET show" do
      it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
        get :show, {:id => <%= file_name %>.to_param}
        assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
      end
    end

    describe "GET new" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :new }
      end
    end

    describe "GET edit" do
      it_should_behave_like "access_denied" do
        subject(:connect) { get :edit, {:id => <%= file_name %>.to_param} }
      end
    end

    describe "POST create" do
      it_should_behave_like "access_denied" do
        subject(:connect) { post :create, {:<%= file_name %> => valid_attributes} }
      end
    end

    describe "PUT update" do
      it_should_behave_like "access_denied" do
        subject(:connect) { put :update, {:id => <%= file_name %>.to_param, :<%= file_name %> => valid_attributes} }
      end
    end

    describe "DELETE destroy" do
      it_should_behave_like "access_denied" do
        subject(:connect) { delete :destroy, {:id => <%= file_name %>.to_param} }
      end
    end
  end

  describe "authorized user" do
    before(:each) { sign_in create(:user) }

  <% unless options[:singleton] -%>
    describe "GET index" do
      it "assigns all <%= table_name.pluralize %> as @<%= table_name.pluralize %>" do
        <%= file_name %> # create <%= file_name %>
        get :index
        assigns(:<%= table_name %>).should eq([<%= file_name %>])
      end
    end
  <% end -%>

    describe "GET new" do
      it "assigns a new <%= ns_file_name %> as @<%= ns_file_name %>" do
        get :new
        assigns(:<%= ns_file_name %>).should be_a_new(<%= class_name %>)
      end
    end

    describe "GET edit" do
      it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
        get :edit, {:id => <%= file_name %>.to_param}
        assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new <%= class_name %>" do
          expect {
            post :create, {:<%= ns_file_name %> => valid_attributes}
          }.to change(<%= class_name %>, :count).by(1)
        end

        it "assigns a newly created <%= ns_file_name %> as @<%= ns_file_name %>" do
          post :create, {:<%= ns_file_name %> => valid_attributes}
          assigns(:<%= ns_file_name %>).should be_a(<%= class_name %>)
          assigns(:<%= ns_file_name %>).should be_persisted
        end

        it "redirects to the created <%= ns_file_name %>" do
          post :create, {:<%= ns_file_name %> => valid_attributes}
          response.should redirect_to(<%= class_name %>.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved <%= ns_file_name %> as @<%= ns_file_name %>" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          post :create, {:<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %>}
          assigns(:<%= ns_file_name %>).should be_a_new(<%= class_name %>)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          post :create, {:<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %>}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested <%= ns_file_name %>" do
          <%= class_name %>.any_instance.should_receive(:update_attributes).with(<%= formatted_hash(example_params_for_update) %>)
          put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => <%= formatted_hash(example_params_for_update) %>}
        end

        it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
          put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => valid_attributes}
          assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
        end

        it "redirects to the <%= ns_file_name %>" do
          put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => valid_attributes}
          response.should redirect_to(<%= file_name %>)
        end
      end

      describe "with invalid params" do
        it "assigns the <%= ns_file_name %> as @<%= ns_file_name %>" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %>}
          assigns(:<%= ns_file_name %>).should eq(<%= file_name %>)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          put :update, {:id => <%= file_name %>.to_param, :<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %>}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested <%= ns_file_name %>" do
        <%= file_name %> # create <%= file_name %>
        expect {
          delete :destroy, {:id => <%= file_name %>.to_param}
        }.to change(<%= class_name %>, :count).by(-1)
      end

      it "redirects to the <%= table_name %> list" do
        delete :destroy, {:id => <%= file_name %>.to_param}
        response.should redirect_to(<%= index_helper %>_url)
      end
    end
  end

end
<% end -%>
