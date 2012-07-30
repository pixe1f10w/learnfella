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

      before { sign_in user }

      it { should have_title user.name }
      it { should have_link 'Users', href: users_path }
      it { should have_link 'Profile', href: user_path( user ) }
      it { should have_link 'Settings', href: edit_user_path( user ) }
      it { should have_link 'Sign out', href: signout_path }
      it { should_not have_link 'Sign in', href: signin_path }

      describe 'followed by signout' do
        before { sign_out }

        it { should have_link 'Sign in' }
        it { should have_notice_message 'signed out' }
      end
    end

    describe 'after visiting another page' do
      before { click_link 'Home' }

      it { should_not have_error_message 'Invalid' }
    end
  end

  describe 'authorization' do
    describe 'for non-signed-in users' do
      let( :user ) { FactoryGirl.create :user }

      describe 'in the Users controller' do
        describe 'visiting the user index' do
          before { visit users_path }

          it  { should have_title 'Sign in' }
        end

        describe 'visiting the edit page' do
          before { visit edit_user_path( user ) }

          it { should have_title 'Sign in' }
        end

        describe 'submitting to the update action' do
          before { put user_path( user ) }

          specify { response.should redirect_to signin_path }
        end

        describe 'as a wrong user' do
          let( :user ) { FactoryGirl.create :user }
          let( :wrong_user ) { FactoryGirl.create :user, email: 'wrong@example.com' }
          before { sign_in user }

          describe 'visiting Users#edit page' do
            before { visit edit_user_path wrong_user }
            it { should_not have_title 'Edit user' }
          end

          describe 'submitting a PUT request to the User#update action' do
            before { put user_path( wrong_user ) }
            specify { response.should redirect_to root_path }
          end
        end

        describe 'as a non-admin user' do
          let( :user ) { FactoryGirl.create :user }
          let( :non_admin ) { FactoryGirl.create :user }

          before { sign_in non_admin }

          describe 'submitting a delete request to Users#destroy action' do
            before { delete user_path user }
            specify { response.should redirect_to root_path }
          end
        end

        describe 'when attempting to visit a protected page' do
          before do
            visit edit_user_path user
            fill_in 'Email',    with: user.email
            fill_in 'Password', with: user.password
            click_button 'Sign in'
          end

          describe 'after signing in' do
            it 'should render the desired protected page' do
              page.should have_title 'Edit user'
            end
          end
        end
      end
    end
  end
end
