class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    CurrentUser.from_session(developer_id: session[:developer_id], recruiter_id: session[:recruiter_id])
  end
end
