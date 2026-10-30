FactoryBot.define do
  factory :page_image do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "vendor/assets/images/rails.png"), "image/png") }
  end
end
