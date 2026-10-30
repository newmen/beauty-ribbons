FactoryBot.define do
  factory :pre_order do
    username { "Raisa Ivanovna" }
    email { "raisa@mail.ru" }
    expected_cost { 0 }
    comment { "I need it!" }
  end
end
