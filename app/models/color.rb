class Color < ProductFilter
  validates :value, presence: true, uniqueness: true, format: /\A[0-9a-fA-F]{6}\Z/

  class << self
    include ColorsHelper

    def rainbow
      all.sort_by do |color|
        hsl(color.value)
      end
    end

    def most_common(products)
      super.rainbow
    end
  end
end
