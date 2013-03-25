# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    category
    cover { |c| c.association(:product_image) }
    name "Beautiful picture"
    description "Shocking picture of her looking"
    width 210
    height 350
    price 2990
    is_archived false

    factory :archived_product do
      is_archived true
    end

    factory :smaller_old_price_product do
      old_price 1000
    end

    factory :sale_product do
      old_price 5000
    end

    factory :badged_product do
      badge

      factory :badged_smaller_old_price_product do
        old_price 1000
      end

      factory :badged_sale_product do
        old_price 5000
      end

      factory :badged_archived_product do
        is_archived true
      end
    end
  end
end
