class ProductSweeper < ActionController::Caching::Sweeper
  observe :product

  def sweep(product)
    expire_fragment('sitemap')
    expire_page(sitemap_path)
    expire_page(atom_path)
  end

  alias_method :after_create, :sweep
  alias_method :after_destroy, :sweep
end