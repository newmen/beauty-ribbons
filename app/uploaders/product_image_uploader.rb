class ProductImageUploader < BaseUploader

  process resize_to_fit: [1082, 1082]

  [
      [:preview, [531, 531]],
      [:similar, [251, 251]],
      [:thumb, [181, 181]],
      [:sample, [111, 111]],
      [:smallest, [22, 22]],
  ].each do |name, sizes|
    version name do
      process resize_to_fit: sizes
    end
  end

end
