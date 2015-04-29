class DevelopersController < ApplicationController
  def index
    @candidates = current_user.developer_listings.paginate(page: params[:page], per_page: 20)
  end

  def search
    @location = params.fetch("location", nil)
    @languages = params.fetch("languages", "")

    @candidates = RecruiterExtensions::SearchDevelopers.new(location: @location, languages: @languages.split(",")).search.paginate(page: params[:page], per_page: 20)
  end

  def filter
    @location = params.fetch("location", "all")
    @language = params.fetch("language", "all")
    lat = params["lat"]
    lng = params["lng"]
    @geolocation = (lat && lng) ? "#{lat},#{lng}" : 'all'

    # Only for map rendering purposes
    if @location != "all"
      location = Geokit::Geocoders::MapboxGeocoder.geocode(@location).ll
      default_lat, default_lng = location.split(',')
    else
      default_lat = 50.9167536
      default_lng = -1.4004929
    end

    @current_lat = lat || default_lat
    @current_lng = lng || default_lng

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

  def contact
    developer = DeveloperProfilePresenter.new(
      subject: Developer.find_by_secure_reference(params[:secure_reference]),
      viewer: current_user.user)

    current_user.contact_developer(developer, message: params.fetch(:body))

    redirect_to root_path
  end
end
