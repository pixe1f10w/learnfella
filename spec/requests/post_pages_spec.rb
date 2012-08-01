require 'spec_helper'

describe "Post pages" do
  subject { page }

  let( :user ) { FactoryGirl.create :user }
  before { sign_in user }

  describe 'post creation' do
    before { visit root_path }

    describe 'with invalid information' do
      it 'should not create a post' do
        expect { click_button 'Post' }.should_not change Post, :count
      end

      describe 'error messages' do
        before { click_button 'Post' }

        it { should have_content 'error' }
      end
    end

    describe 'with valid information' do
      before { fill_in 'post_content', with: 'Lorem ipsum' }

      it 'should create a post' do
        expect { click_button 'Post' }.should change( Post, :count ).by 1
      end
    end
  end

  describe 'post destruction' do
    before { FactoryGirl.create :post, user: user }

    describe 'as correct user' do
      before { visit root_path }

      it 'should delete a post' do
        expect { click_link 'delete' }.should change( Post, :count ).by -1
      end
    end
  end

end
