class PageImage < ActiveRecord::Base
  mount_uploader :image, PageImageUploader

  validates_presence_of :image
end
