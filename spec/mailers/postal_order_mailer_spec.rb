require "spec_helper"

describe PostalOrderMailer do
  let(:order) { create(:postal_order) }
  let(:from_email) { SecureSettings.contacts.email }

  describe "admin notice" do
    let(:to_email) { SecureSettings.contacts.email }
    let(:mail) { PostalOrderMailer.admin_notice(order) }

    it_behaves_like "valid_email"
    it_behaves_like "each_part_has_email_content" do
      let(:content) { 'заказ' }
    end
  end

  describe "customer notice" do
    let(:to_email) { order.email }

    describe "checkout" do
      let(:mail) { PostalOrderMailer.checkout_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end

    describe "process" do
      let(:mail) { PostalOrderMailer.process_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end

    describe "complete" do
      let(:mail) { PostalOrderMailer.complete_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end

    describe "cancel" do
      let(:mail) { PostalOrderMailer.cancel_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end
  end

end
