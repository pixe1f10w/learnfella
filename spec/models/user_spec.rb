# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

require 'spec_helper'

describe User do
  before { @user = User.new( name: 'Example User', email: 'user@example.com',
                             password: 'foobar', password_confirmation: 'foobar' ) }

  subject{ @user }

  it { should respond_to( :name ) }
  it { should respond_to( :email ) }
  it { should respond_to( :password_digest ) }
  it { should respond_to( :password ) }
  it { should respond_to( :password_confirmation ) }
  it { should respond_to( :remember_token ) }
  it { should respond_to( :authenticate ) }
  it { should respond_to( :admin ) }
  it { should respond_to( :posts ) }
  it { should respond_to( :feed  ) }
  it { should respond_to( :relationships ) }
  it { should respond_to( :followed_users ) }
  it { should respond_to( :following? ) }
  it { should respond_to( :follow! ) }
  it { should respond_to( :unfollow! ) }
  it { should respond_to( :reverse_relationships ) }
  it { should respond_to( :followers ) }

  it { should be_valid }
  it { should_not be_admin }

  describe 'following' do
    let( :other_user ) { FactoryGirl.create :user }

    before do
      @user.save
      @user.follow! other_user
    end

    it { should be_following other_user }
    its( :followed_users ) { should include other_user }

    describe 'followed user' do
      subject { other_user }
      its( :followers ) { should include @user }
    end

    describe 'and unfollowing' do
      before { @user.unfollow! other_user }

      it { should_not be_following other_user }
      its( :followed_users ) { should_not include other_user }
    end
  end

  describe 'posts association' do
    before { @user.save }
    let!( :older_post ) do
      FactoryGirl.create :post, user: @user, created_at: 1.day.ago
    end

    let!( :newer_post ) do
      FactoryGirl.create :post, user: @user, created_at: 1.hour.ago
    end

    it 'should have the right posts in the right order' do
      @user.posts.should == [ newer_post, older_post ]
    end

    it 'should destroy associated posts' do
      posts = @user.posts
      @user.destroy

      posts.each do |post|
        #post.find_by_id( post.id ).should be_nil
        ->() { Post.find post.id }.should raise_error ActiveRecord::RecordNotFound
      end
    end

    describe 'status' do
      let( :unfollowed_post ) { FactoryGirl.create :post, user: FactoryGirl.create( :user ) }
      let( :followed_user ) { FactoryGirl.create :user }

      before do
        @user.follow! followed_user
        3.times { followed_user.posts.create! content: 'Lorem ipsum' }
      end

      its( :feed ) { should include newer_post }
      its( :feed ) { should include older_post }
      its( :feed ) { should_not include unfollowed_post }
      its( :feed ) do
        followed_user.posts.each do |post|
          should include post
        end
      end
    end
  end

  describe 'with admin attribute set to true' do
    before do
      @user.save!
      @user.toggle! :admin
    end

    it { should be_admin }
  end

  describe 'accessible attributes' do
    it 'should not allow access to admin' do
      expect { User.new admin: true }.should raise_error ActiveModel::MassAssignmentSecurity::Error
    end
  end

  describe 'remember token' do
    before { @user.save }

    its( :remember_token ) { should_not be_blank }
  end

  describe 'when name is not present' do
    before { @user.name = ' ' }

    it { should_not be_valid }
  end

  describe 'when name is too long' do
    before { @user.name = 'a' * 51 }

    it { should_not be_valid }
  end

  describe 'when password is not present' do
    before { @user.password = @user.password_confirmation = ' ' }

    it { should_not be_valid }
  end

  describe 'when password does not match confirmation' do
    before { @user.password_confirmation = 'mismatch' }

    it { should_not be_valid }
  end

  describe 'when password confirmation is nil' do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe 'when password is too short' do
    before { @user.password = @user.password_confirmation = 'a' * 5 }

    it { should be_invalid }
  end

  describe 'return value of authenticate method' do
    before { @user.save }

    let( :found_user ) { User.find_by_email( @user.email ) }

    describe 'with valid password' do
      it { should == found_user.authenticate( @user.password ) }
    end

    describe 'with invalid password' do
      let( :user_for_invalid_password ) { found_user.authenticate( 'invalid' ) }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe 'when email is not present' do
    before { @user.email = ' ' }

    it { should_not be_valid }
  end

  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+bar.com]
      addresses.each do |invalid_addr|
        @user.email = invalid_addr
        @user.should_not be_valid
      end
    end
  end

  describe 'when email format is valid' do
    it 'should be invalid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_addr|
        @user.email = valid_addr
        @user.should be_valid
      end
    end
  end

  describe 'when email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe 'email address with mixed case' do
    let( :mixed_case_email ) { 'fOo@ExAmple.com' }

    it 'should be saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end
end
