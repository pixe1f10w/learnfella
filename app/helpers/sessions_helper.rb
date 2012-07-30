module SessionsHelper
  def sign_in user
    cookies.permanent[ :remember_token ] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    not current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete :remember_token
  end

  def current_user= user
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token cookies[ :remember_token ]
  end

  def current_user? user
    @current_user == user
  end

  def redirect_back_or_to location
    redirect_to session[ :return_to ] || location
    session.delete :return_to
  end

  def store_location
    session[ :return_to ] = request.fullpath
  end
end
