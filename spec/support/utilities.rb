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

def invalid_signin
  click_button 'Sign in'
end

def signout

  click_link 'Sign out'
end

def enter_valid_credentials
  fill_in 'Name',     with: 'Example User'
  fill_in 'Email',    with: 'user@example.com'
  fill_in 'Password', with: 'foobar'
  fill_in 'Confirmation', with: 'foobar'
end

RSpec::Matchers.define :have_title do |msg|
  match do |page|
    page.should have_selector 'title', text: msg
  end
end

RSpec::Matchers.define :have_header do |msg|
  match do |page|
    page.should have_selector 'h1', text: msg
  end
end

RSpec::Matchers.define :have_error_explanation do 
  match do |page|
    page.should have_selector 'div', id: 'error_explanation'
  end
end

RSpec::Matchers.define :have_error_message do |msg|
  match do |page|
    page.should have_selector 'div.alert.alert-error', text: msg
  end
end

RSpec::Matchers.define :have_notice_message do |msg|
  match do |page|
    page.should have_selector 'div.alert.alert-notice', text: msg
  end
end

RSpec::Matchers.define :have_success_message do |msg|
  match do |page|
    page.should have_selector 'div.alert.alert-success', text: msg
  end
end
