class ProductImagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @product_image = ProductImage.create(product_image_params)
  end

  def destroy
    @product_image = ProductImage.find(params[:id])
    @product_image.destroy
  end

  private

  def product_image_params
    params.fetch(:product_image, {}).permit(:image, :product_id)
  end
end
