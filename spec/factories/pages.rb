# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title "Some page"
    markdown "some markdown text"

    before(:create) do |page|
      page.identifier = "some_page"
    end
  end

  factory :delivery_page, class: Page do
    title "Delivery"
    markdown "We use mail delivery"

    before(:create) do |page|
      page.identifier = "delivery"
    end
  end

  factory :welcome_page, class: Page do
    title "Welcome"
    markdown "Glad to see you on our wonderful website. We have many products and customers."

    before(:create) do |page|
      page.identifier = "welcome"
    end
  end
end
