class OrderMailer < ActionMailer::Base
  default from: SecureSettings.contacts.email_with_name

  def admin_notice(order)
    @order = order
    mail to: SecureSettings.contacts.email
  end

  def checkout_notice(order)
    setup_and_render(order)
  end

  def process_notice(order)
    setup_and_render(order)
  end

  def complete_notice(order)
    setup_and_render(order)
  end

  def cancel_notice(order)
    setup_and_render(order)
  end

  private

  def setup_and_render(order)
    @order = order
    mail to: order.email_with_name
  end
end
