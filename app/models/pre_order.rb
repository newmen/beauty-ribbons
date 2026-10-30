class PreOrder < Order
  monetize :expected_cost_cents

  validates_presence_of :username
  validates_numericality_of :expected_cost, allow_nil: true
  validates :email, presence: true, format: BeautyRibbons::Application.email_regexp

  private

  def do_checkout
    PreOrderMailer.admin_notice(self).deliver_now
    PreOrderMailer.checkout_notice(self).deliver_now
  end

  def do_process
    # PreOrderMailer.process_notice(self).deliver_now
  end

  def do_complete
    PreOrderMailer.complete_notice(self).deliver_now
  end

  def do_cancel
    PreOrderMailer.cancel_notice(self).deliver_now
  end
end
