class RecruitersController < ApplicationController
  def create
    data = request.env['omniauth.auth']
    recruiter = RecruiterExtensions::BuildDevRecruiterProfile.new(data).perform
    session[:recruiter_id] = recruiter.id

    redirect_to recruiter_profile_path(recruiter.id)
  end

  def show
    @recruiter = RecruiterProfilePresenter.new(
      subject: DevRecruiter.find(params[:id]),
      viewer: current_user.user)
  end

  def following
    @recruiter = RecruiterProfilePresenter.new(
      subject: DevRecruiter.find(params[:id]),
      viewer: current_user.user)

    redirect_to root_path unless @recruiter.can_see_following?

    @developers = @recruiter.following.paginate(page: params[:page], per_page: 20)
  end
end
