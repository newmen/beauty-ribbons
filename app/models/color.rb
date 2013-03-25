class Color < ProductFilter
  attr_accessible :value

  validates :value, presence: true, uniqueness: true, format: /\A[0-9a-fA-F]{6}\Z/

  class << self
    include ColorsHelper

    def rainbow
      scoped.sort do |a, b|
        a_hsl, b_hsl = [a, b].map do |c|
          sass_color(c.value).hsl
        end
        a_hsl <=> b_hsl
      end
    end

    def most_common(products)
      super.rainbow
    end
  end

end
