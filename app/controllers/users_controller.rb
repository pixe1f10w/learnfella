class UsersController < ApplicationController
  before_filter :signed_in_user, only: [ :edit, :update, :index, :destroy, :followers, :following ]
  before_filter :correct_user, only: [ :edit, :update ]
  before_filter :admin_user, only: :destroy
  before_filter :already_signed_in, only: [ :new, :create ]

  def index
    @users = User.paginate page: params[ :page ]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[ :user ]
    if @user.save
      sign_in @user
      flash[ :success ] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    user = User.find params[ :id ]

    unless user.admin? and user == current_user
      user.destroy
      flash[ :success ] = 'User destroyed.'
    end

    redirect_to users_path
  end

  def show
    @user = User.find params[ :id ]
    @posts = @user.posts.paginate( page: params[ :page ] )
  end

  def edit
    @user = User.find params[ :id ]
  end

  def update
    @user = User.find params[ :id ]
    if @user.update_attributes params[ :user ]
      flash[ :success ] = 'Profile updated successfully'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = 'Following'
    @user = User.find params[ :id ]
    @users = @user.followed_users.paginate page: params[ :page ]
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find params[ :id ]
    @users = @user.followers.paginate page: params[ :page ]
    render 'show_follow'
  end

  private
    def correct_user
      @user = User.find params[ :id ]
      redirect_to root_path, error: 'Insufficient privileges to access requested page' unless current_user? @user
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def already_signed_in
      redirect_to root_path if signed_in?
    end
end
