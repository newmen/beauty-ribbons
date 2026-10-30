class ProductImage < ActiveRecord::Base
  mount_uploader :image, ProductImageUploader

  belongs_to :product, optional: true

  validates_presence_of :image
end
