module ControllerExamples
  shared_examples "access_denied" do
    it "returns http redirect" do
      connect
      response.should redirect_to(new_user_session_path)
    end
  end

  shared_examples "unauthorized_explained" do
    it "returns 401 response" do
      connect
      response.response_code.should eq(401)
    end
  end
end