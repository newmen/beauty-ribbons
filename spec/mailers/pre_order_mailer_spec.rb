require "spec_helper"

describe PreOrderMailer do
  let(:order) { create(:pre_order) }
  let(:from_email) { SecureSettings.contacts.email }

  describe "admin notice" do
    let(:to_email) { SecureSettings.contacts.email }
    let(:mail) { PreOrderMailer.admin_notice(order) }

    it_behaves_like "valid_email"
    it_behaves_like "each_part_has_email_content" do
      let(:content) { 'предзаказ' }
    end
  end

  describe "customer notice" do
    let(:to_email) { order.email }

    describe "checkout" do
      let(:mail) { PreOrderMailer.checkout_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end

    describe "process" do
      let(:mail) { PreOrderMailer.process_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end

    describe "complete" do
      let(:mail) { PreOrderMailer.complete_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end

    describe "cancel" do
      let(:mail) { PreOrderMailer.cancel_notice(order) }
      it_behaves_like "valid_email_with_good_content"
    end
  end

end
