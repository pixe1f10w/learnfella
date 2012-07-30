class UsersController < ApplicationController
  before_filter :signed_in_user, only: [ :edit, :update, :index, :destroy ]
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

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: 'Please sign in to access this page'
      end
    end

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
