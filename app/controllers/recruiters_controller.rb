class RecruitersController < ApplicationController
  def create
    data = request.env['omniauth.auth']
    recruiter = RecruiterExtensions::BuildDevRecruiterProfile.new(data).perform
    session[:recruiter_id] = recruiter.id

    redirect_to root_path
  end
end
