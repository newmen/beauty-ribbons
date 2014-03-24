module MailerExamples
  shared_examples_for "valid_headers" do
    it "renders the headers" do
      mail.to.should eq([to_email])
      mail.from.should eq([from_email])
    end
  end

  shared_examples_for "multipart_email" do
    it "generates a multipart message (plain text and html)" do
      mail.body.parts.length.should eq(2)
      mail.body.parts.collect(&:content_type).should include('text/plain; charset=UTF-8', 'text/html; charset=UTF-8')
    end
  end

  shared_examples_for "email_content" do
    it "has content" do
      part.should match(content)
    end
  end

  shared_examples_for "good_content" do
    it "has good content" do
      part.should match("Здравствуйте")
      part.should match("Спасибо")
    end
  end

  [
    'email_content',  # -> shared_examples_for "each_part_has_email_content"
    'good_content'    # -> shared_examples_for "each_part_has_good_content"
  ].each do |content_example_name|
    shared_examples_for "each_part_has_#{content_example_name}" do
      describe "text version" do
        it_behaves_like content_example_name do
          let(:part) { get_message_part(mail, /plain/) }
        end
      end

      describe "html version" do
        it_behaves_like content_example_name do
          let(:part) { get_message_part(mail, /html/) }
        end
      end
    end
  end

  shared_examples_for "valid_email" do
    it_behaves_like "valid_headers"
    it_behaves_like "multipart_email"
  end

  shared_examples_for "valid_email_with_good_content" do
    it_behaves_like "valid_email"
    it_behaves_like "each_part_has_good_content"
  end

end