require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe 'signin page' do
    before { visit signin_path }
    
    let( :signin ) { 'Sign in' }

    it { should have_header signin }
    it { should have_title signin }

    describe 'with invalid information' do
      before { invalid_signin }
      
      it { should have_header signin }
      it { should have_error_message 'Invalid' }
    end

    describe 'with valid information' do
      let( :user ) { FactoryGirl.create :user }

      before { valid_signin user }

      it { should have_title user.name }
      it { should have_link 'Profile', href: user_path( user ) }
      it { should have_link 'Sign out', href: signout_path }
      it { should_not have_link 'Sign in', href: signin_path }

      describe 'followed by signout' do
        before { signout }

        it { should have_link 'Sign in' }
        it { should have_notice_message 'signed out' }
      end
    end

    describe 'after visiting another page' do
      before { click_link 'Home' }

      it { should_not have_error_message 'Invalid' }
    end
  end
end
