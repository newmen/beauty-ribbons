Given /^"([^"]+)" category with "([^"]+)"( \S+)? product$/ do |category_name, product_name, product_type|
  category = FactoryGirl.create(:category, name: category_name)
  factory_name = product_type ? "#{product_type.strip}_product" : 'product'
  FactoryGirl.create(factory_name.to_sym, category: category, name: product_name)
end

Given /^"([^"]+)" product state is set to (un)?archived$/ do |product_name, is_unarchived|
  product = Product.find_by_name(product_name)
  product.is_archived = !is_unarchived
  product.save
end

Given /^"([^"]+)" product is( not)? archived$/ do |product_name, negate|
  product = Product.find_by_name(product_name)
  product.is_archived.should(negate ? be_false : be_true)
end

Given /follows archive$/ do
  visit archived_path
end