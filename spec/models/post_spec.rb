require 'spec_helper'

describe Post do
  let( :user ) { FactoryGirl.create :user }
  before { @post = user.posts.build content: 'Lorem ipsum' }

  subject { @post }

  it { should respond_to :content }
  it { should respond_to :user_id }
  it { should respond_to :user }
  its( :user ) { should == user }

  it { should be_valid }

  describe 'when user_id is not present' do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end

  describe 'with blank content' do
    before { @post.content = ' ' }
    it { should_not be_valid }
  end

  describe 'with content that is too long' do
    before { @post.content = 'a' * 256 }
    it { should_not be_valid }
  end

  describe 'accessible attributes' do
    it 'should now allow access to user_id' do
      expect { Post.new user_id: user.id }.should raise_error ActiveModel::MassAssignmentSecurity::Error
    end
  end
end
# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

