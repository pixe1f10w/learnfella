require 'spec_helper'

describe 'Static pages' do
  let( :base_title ) { "Ruby on Rails Tutorial Sample App" }

  describe 'Home page' do
    it "should have the h1 'Sample App'" do
      visit '/static_pages/home'
      #page.should have_content 'Sample App'
      page.should have_selector 'h1', :text => 'Sample App'
    end

    it "should have the base title" do
      visit '/static_pages/home'
      page.should have_selector 'title', :text => base_title
    end

    it "should not have the custom title 'Home'" do
      visit '/static_pages/home'
      page.should_not have_selector 'title', :text => "#{base_title} | Home"
    end
  end

  describe 'Help page' do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      #page.should have_content 'Help'
      page.should have_selector 'h1', :text => 'Help'
    end

    it "should have the right title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector 'title', :text => "#{base_title} | Help"
    end
  end

  describe 'About page' do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      #page.should have_content 'About Us'
      page.should have_selector 'h1', :text => 'About Us'
    end

    it "should have the right title 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector 'title', :text => "#{base_title} | About Us"
    end
  end

  describe 'Contact page' do
    it "should have the content 'Contact information'" do
      visit '/static_pages/contact'
      page.should have_selector 'h1', :text => 'Contact information'
    end

    it "should have the right title 'Contact'" do
      visit '/static_pages/contact'
      page.should have_selector 'title', :text => "#{base_title} | Contact"
    end
  end
end
