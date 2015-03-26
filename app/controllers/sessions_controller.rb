class SessionsController < ApplicationController
  def logout
    session[:developer_id] = nil
    redirect_to root_path
  end
end
