def user
  {
    username: 'Mary Poppins',
    email: 'marypopins@gmail.com',
    zipcode: '123321',
    city: 'Moscow',
    street_line: '1 octover, 33'
  }
end

def postal_order_params
  { postal_order: user }
end

def pre_order_params
  params = user.select { |k, _| [:username, :email].include?(k) }
  params[:expected_cost] = ''
  { pre_order: params }
end

def humanize_state(order_type, state)
  I18n.t("#{order_type}_orders.state.#{state}")
end

Given /clicks to checkout "([^"]+)" product$/ do |product_name|
  page.find('strong', text: product_name).first(:xpath, './/..//..').find('.checkout-button a', visible: true).click
end

Given /goes to cart$/ do
  visit cart_path
end

Given /clicks to checkout (\S+) products$/ do |products_type|
  page.find(".#{products_type}-products .create-order a").click
end

Given /fill (\S+) order form$/ do |order_type|
  send("#{order_type}_order_params")["#{order_type}_order".to_sym].each do |k, v|
    fill_in "#{order_type}_order_#{k}", with: v
  end
end

Given /^(user|customer|admin) receive an (\S+) order (.+) email$/ do |recipient, order_type, email_type|
  email = recipient == 'admin' ? SecureSettings.contacts.email : user[:email]
  subject = I18n.t("#{order_type}_order_mailer.#{email_type}_notice.subject")
  step %("#{email}" should receive an email with subject "#{subject}")
end

Given /^order (for delivery|to manufacture) of "([^"]+)" product$/ do |order_type, product_name|
  order_type = order_type == 'for delivery' ? 'postal_order' : 'pre_order'
  order = order_type.classify.constantize.create(send("#{order_type}_params")[order_type.to_sym])
  order.products << Product.find_by_name(product_name)
  order.save
end

Given /should see (\S+) (\S+) order state$/ do |state, order_type|
  page.should have_content humanize_state(order_type, state)
end

Given /clicks (\S+) (\S+) order$/ do |state, order_type|
  page.find('a', text: humanize_state(order_type, state)).click
end

Given /^order state is set to (\S+)$/ do |state|
  order = Order.first
  order.state = state
  order.save
end


Given /^order state is (\S+)$/ do |state|
  Order.first.state.should eq state
end
