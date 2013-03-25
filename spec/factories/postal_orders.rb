# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postal_order do
    username 'Vova Putin'
    email 'putin@gmail.com'
    zipcode '123456'
    country 'Russia'
    region 'Moscow'
    city 'Moscow'
    street_line 'Red Sq. #1'
    comment 'Fast and go!'
    amount 5550
  end
end
