# coding: utf-8
require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    let( :submit ) { 'Create my account' }

    it { should have_header 'Sign up' }
    it { should have_title full_title( 'Sign up' ) }

    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change User, :count
      end

      describe 'after submission' do
        before { click_button submit }

        it { should have_title 'Sign up' }
        it { should have_error_explanation }
      end
    end

    describe 'with valid information' do
      before { enter_valid_credentials }

      it 'should create a user' do
        expect { click_button submit }.to change( User, :count ).by 1
      end

      describe 'after saving a user' do
        before { click_button submit }
        let( :user ) { User.find_by_email 'user@example.com' }

        it { should have_title user.name }
        it { should have_success_message 'Welcome' }
        it { should have_link 'Sign out' }
      end
    end
  end

  describe "profile page" do
    let( :user ) { FactoryGirl.create :user }
    before { visit user_path( user ) }

    it { should have_header user.name }
    it { should have_title user.name }
  end
end
