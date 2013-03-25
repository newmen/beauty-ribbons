require 'spec_helper'

describe ControlPanelController do

  describe "GET 'index'" do
    describe 'unauthorized user' do
      it_should_behave_like "access_denied" do
        subject(:connect) { get 'index' }
      end
    end

    describe "authorized user" do
      before { sign_in create(:user) }
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

  end
end
