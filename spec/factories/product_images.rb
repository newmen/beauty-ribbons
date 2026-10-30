FactoryBot.define do
  factory :product_image do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "vendor/assets/images/rails.png"), "image/png") }
  end
end
