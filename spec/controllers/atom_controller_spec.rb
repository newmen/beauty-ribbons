require 'spec_helper'

describe AtomController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', format: :atom
      response.should be_success
    end
  end

end
