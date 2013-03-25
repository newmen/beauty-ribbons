Before do
  FactoryGirl.create(:welcome_page)
  FactoryGirl.create(:delivery_page)
end

Given /on welcome page$/ do
  visit root_path
end

Given /on (.+) edit page$/ do |obj_type|
  obj = obj_type.classify.constantize.first
  visit url_for([:edit, obj])
end

Given /follows "([^"]+)"$/ do |link_name|
  first('a', text: link_name).click
end

Given /clicks to submit$/ do
  page.find('[type="submit"]').click
end

Given /should( not)? see "([^"]+)"/ do |negate, content|
  negate ? page.should_not(have_content(content)) : page.should(have_content(content))
end

Given /should see (.+) message$/ do |message|
  message = message.gsub(' ', '_')
  page.should have_content I18n.t("controller.#{message}")
end

Given /^admin is signed in$/ do
  FactoryGirl.create(:admin)
  admin = FactoryGirl.attributes_for(:admin)
  visit new_user_session_path
  fill_in 'user_email', with: admin[:email]
  fill_in 'user_password', with: admin[:password]
  step 'clicks to submit'
end
