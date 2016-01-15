class SessionsController < ApplicationController
  def logout
    session[:developer_id] = nil
    session[:recruiter_id] = nil
    session["current_search"] = {}
    redirect_to root_path
  end
end
