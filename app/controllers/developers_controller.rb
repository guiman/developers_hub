class DevelopersController < ApplicationController
  def index
    @candidates = current_user.developer_listings.paginate(page: params[:page], per_page: 20)
  end

  def filter
    @location = params.fetch("location", "all")
    @language = params.fetch("language", "all")
    lat = params["lat"]
    lng = params["lng"]
    @geolocation = (lat && lng) ? "#{lat},#{lng}" : 'all'

    # Only for map rendering purposes
    @current_lat = lat || 50.9167536
    @current_lng = lng || -1.4004929

    @map_data = RecruiterExtensions::LanguageStatisticsByLocation.new(
      @language).perform

    @candidates = current_user.developer_listings(language: @language,
      geolocation: @geolocation, location: @location).paginate(page: params[:page], per_page: 20)
  end

  def show
    @developer = DeveloperProfilePresenter.new(
      subject: Developer.find_by_secure_reference(params[:secure_reference]),
      viewer: current_user.user)
    redirect_to root_path unless @developer.can_be_displayed?
  end

  def create
    developer = RecruiterExtensions::BuildDeveloperProfile.new(request.env['omniauth.auth']).perform
    session[:developer_id] = developer.id

    redirect_to developer_profile_path(developer.secure_reference)
  end
end
