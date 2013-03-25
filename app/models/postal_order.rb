class PostalOrder < Order
  attr_accessible :zipcode, :country, :region, :city, :street_line, :amount

  monetize :amount_cents
  validates_presence_of :username, :zipcode, :city, :street_line, :amount
  validates_numericality_of :amount, greater_than: 0
  validates :email, presence: true, format: BeautyRibbons::Application.email_regexp

  before_validation :count_amount

  def complete_address
    [
      country,
      zipcode,
      !region.blank? && I18n.t('activerecord.attributes.postal_order.full_region', region: region),
      city,
      street_line
    ].reject(&:blank?).join(', ')
  end

  private

  def count_amount
    self.amount = products.map(&:price).inject(:+)
  end

  def do_checkout
    products.update_all(['is_archived = ?', true])
    PostalOrderMailer.admin_notice(self).deliver
    PostalOrderMailer.checkout_notice(self).deliver
  end

  def do_process
    PostalOrderMailer.process_notice(self).deliver
  end

  def do_complete
    PostalOrderMailer.complete_notice(self).deliver
  end

  def do_cancel
    products.update_all(['is_archived = ?', false])
    PostalOrderMailer.cancel_notice(self).deliver
  end
end
