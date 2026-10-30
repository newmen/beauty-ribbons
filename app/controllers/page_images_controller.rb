class PageImagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @page_image = PageImage.create(page_image_params)
  end

  def destroy
    @page_image = PageImage.find(params[:id])
    @page_image.destroy
  end

  private

  def page_image_params
    params.fetch(:page_image, {}).permit(:image, :page_id)
  end
end
