class ProductImage < ActiveRecord::Base
  attr_accessible :product_id, :image
  mount_uploader :image, ProductImageUploader

  belongs_to :product

  validates_presence_of :image
end
