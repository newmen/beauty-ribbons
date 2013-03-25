class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Removes EXIF data from image.
  def strip
    manipulate! do |image|
      image.strip
      block_given? ? yield(image) : image
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :strip

end
