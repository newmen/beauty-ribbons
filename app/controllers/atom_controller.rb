class AtomController < ApplicationController
  caches_page :index

  def index
    @products = Product.includes(:category)
  end
end
