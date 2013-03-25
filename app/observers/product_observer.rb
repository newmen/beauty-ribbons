class ProductObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers

  observe :product

  def ping(product)
    unless Rails.env.test?
      SitemapPinger.ping(root_url(host: Settings.domain_name))
    end
  end

  alias_method :after_create, :ping
  alias_method :after_destroy, :ping
end
