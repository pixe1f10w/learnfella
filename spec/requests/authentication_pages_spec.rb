require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe 'signin page' do
    before { visit signin_path }
    
    let( :signin ) { 'Sign in' }

    it { should have_selector 'h1', text: signin }
    it { should have_selector 'title', text: signin }

    describe 'with invalid information' do
      before { click_button 'Sign in' }
      
      it { should have_selector 'h1', text: signin }
      it { should have_error_message 'Invalid' }
    end

    describe 'with valid information' do
      let( :user ) { FactoryGirl.create :user }

      before do
        valid_signin user
      end

      it { should have_selector 'title', text: user.name }
      it { should have_link 'Profile', href: user_path( user ) }
      it { should have_link 'Sign out', href: signout_path }
      it { should_not have_link 'Sign in', href: signin_path }

      describe 'followed by signout' do
        before { click_link 'Sign out' }

        it { should have_link 'Sign in' }
      end
    end

    describe 'after visiting another page' do
      before { click_link 'Home' }

      it { should_not have_error_message 'Invalid' }
    end
  end
end
