module SessionsHelper
  # logs in user
  def log_in(user)
    session[:user_id] = user.id
  end

  # return true if user is current user
  def current_user?(user)
    user == current_user
  end

  # return current logged in user (if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # redirect to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # store url tried to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
