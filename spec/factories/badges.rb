FactoryGirl.define do
  factory :badge do
    sequence(:name) { |n| "Badge Name ##{n}" }
    color "099922"
    position 10

    factory :badge_nova do
      position 1
      identifier 'nova'
    end

    factory :badge_sale do
      position 100
      identifier 'sale'
    end
  end
end
