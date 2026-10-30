class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :position, presence: true, numericality: true

  default_scope { order(:position) }
end
