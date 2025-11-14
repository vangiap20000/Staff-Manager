class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Please login"
      redirect_to login_path
    end
  end

  def redirect_if_logged_in
    if logged_in?
      flash[:notice] = "You are already logged in"
      redirect_to root_path
    end
  end

  def is_supper_admin
    unless current_user.role == Rails.configuration.const['role'][:superAdmin]
      flash[:error] = "You are not authorized to access this page."
      redirect_to users_path
    end
  end
end
