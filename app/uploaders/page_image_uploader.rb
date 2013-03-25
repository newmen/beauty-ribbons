class PageImageUploader < BaseUploader

  [
      [:thumb, [390, 390]],
      [:sample, [110, 110]],
  ].each do |name, sizes|
    version name do
      process resize_to_fit: sizes
    end
  end

end
