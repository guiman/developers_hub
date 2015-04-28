class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :prevent_multi_profiles

  def current_user
    CurrentUser.from_session(developer_id: session[:developer_id], recruiter_id: session[:recruiter_id])
  end

  private

  # This should never ever happen!
  def prevent_multi_profiles
    if session[:developer_id] && session[:recruiter_id]
      session[:developer_id] = session[:recruiter_id] = nil
      redirect_to "/sessions/logout"
    end
  end
end
