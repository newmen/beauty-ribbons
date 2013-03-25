class Tag < ProductFilter
  def self.most_common(products)
    super.sort_by { |tag| tag.name }
  end
end
