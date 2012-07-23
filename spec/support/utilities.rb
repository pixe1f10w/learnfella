include ApplicationHelper

def full_title page_title
  title = "Ruby on Rails Tutorial Sample App"
  title << " | #{page_title}" unless page_title.empty?
  title
end

def valid_signin user
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

RSpec::Matchers.define :have_error_message do |msg|
  match do |page|
    page.should have_selector 'div.alert.alert-error', text: msg
  end
end
