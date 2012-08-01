require 'spec_helper'

include ApplicationHelper

describe 'Static pages' do
  subject { page }

  shared_examples_for 'all static pages' do
    it { should have_header heading }
    it { should have_title full_title( page_title ) }
  end

  describe 'Home page' do
    before { visit root_path }

    let( :heading ) { 'Sample App' }
    let( :page_title ) { '' }

    it_should_behave_like 'all static pages'
    it { should_not have_title full_title( 'Home' ) }

    describe 'for signed-in users' do
      let( :user ) { FactoryGirl.create :user }

      before do
        FactoryGirl.create :post, user: user, content: 'Lorem ipsum'
        FactoryGirl.create :post, user: user, content: 'Dolor sit amet'
        sign_in user
        visit root_path
      end

      it 'should render the feed' do
        user.feed.each do |post|
          page.should have_selector "li##{post.id}", text: post.content
        end
      end
    end
  end

  describe 'Help page' do
    before { visit help_path }

    let( :heading ) { 'Help' }
    let( :page_title ) { 'Help' }

    it_should_behave_like 'all static pages'
  end

  describe 'About page' do
    before { visit about_path }

    let( :heading ) { 'About Us' }
    let( :page_title ) { 'About Us' }

    it_should_behave_like 'all static pages'
  end

  describe 'Contact page' do
    before { visit contact_path }

    let( :heading ) { 'Contact information' }
    let( :page_title ) { 'Contact' }

    it_should_behave_like 'all static pages'
  end

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    page.should have_title full_title( 'About Us' )
    click_link 'Help'
    page.should have_title full_title( 'Help' )
    click_link 'Contact'
    page.should have_title full_title( 'Contact' )
    click_link 'Home'
    click_link 'Sign up now!'
    page.should have_title 'Sign up'
    click_link 'sample app'
    page.should have_title 'Sample App'
  end
end
