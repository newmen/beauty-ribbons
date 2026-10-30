class Badge < ActiveRecord::Base
  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :color, presence: true, format: /\A[0-9a-fA-F]{6}\Z/
  validates :position, presence: true, numericality: true

  scope :defaults, -> { where("identifier IS NOT NULL").order("position DESC") }
  scope :not_defaults, -> { where("identifier IS NULL").order("name") }

  class << self
    %w[nova sale].each do |identifier|
      define_method(identifier) do
        find_by(identifier: identifier)
      end
    end
  end
end
