class PageImagesController < ApplicationController
  before_filter :authenticate_user!

  # POST /page_images
  def create
    @page_image = PageImage.create(params[:page_image])
  end

  # DELETE /page_images/1
  def destroy
    @page_image = PageImage.find(params[:id])
    @page_image.destroy
  end
end
