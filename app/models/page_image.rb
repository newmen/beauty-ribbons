class PageImage < ActiveRecord::Base
  attr_accessible :image
  mount_uploader :image, PageImageUploader

  # belongs_to :page

  validates_presence_of :image
end
