class ProductImagesController < ApplicationController
  before_filter :authenticate_user!

  # POST /product_images
  def create
    @product_image = ProductImage.create(params[:product_image])
  end

  # DELETE /product_images/1
  def destroy
    @product_image = ProductImage.find(params[:id])
    @product_image.destroy
  end
end
