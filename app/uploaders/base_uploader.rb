class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def strip
    manipulate! do |image|
      image.strip
      block_given? ? yield(image) : image
    end
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  process :strip
end
