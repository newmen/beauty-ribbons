module ViewExamples
  shared_examples 'see_or_not_button' do |btn_type|
    describe "unauthorized user" do
      it "doen't see #{btn_type} button" do
        render
        rendered.should_not send("have_#{btn_type}_button")
      end
    end

    describe "authorized user" do
      before(:each) { sign_in create(:user) }

      it "sees #{btn_type} button" do
        render
        rendered.should send("have_#{btn_type}_button")
      end
    end
  end

  shared_examples "see_or_not_add_button" do |model_name|
    it_behaves_like 'see_or_not_button', 'add'
  end

  %w(edit destroy).each do |btn_type|
    shared_examples "see_or_not_#{btn_type}_button" do
      it_behaves_like 'see_or_not_button', btn_type
    end
  end
end
