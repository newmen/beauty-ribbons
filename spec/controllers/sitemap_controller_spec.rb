require 'spec_helper'

describe SitemapController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', format: :xml
      response.should be_success
    end
  end

end
