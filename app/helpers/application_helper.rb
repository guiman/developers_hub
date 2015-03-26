module ApplicationHelper
  def current_user
    Developer.find(session[:developer_id])
  end
end
