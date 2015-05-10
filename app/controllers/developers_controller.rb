class DevelopersController < ApplicationController
  before_action :build_presenter, only: [:show, :toggle_public, :contact]

  def index
    @candidates = current_user.developer_listings.paginate(page: params[:page], per_page: 20)
  end

  def search
    @location = params.fetch("location", nil)
    @languages = params.fetch("languages", "")
    developers = current_user.developer_listings
    @candidates = RecruiterExtensions::SearchDevelopers.new(
      location: @location,
      languages: @languages.split(","),
      developers: developers).search.paginate(page: params[:page], per_page: 20)
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
    @candidates = current_user.developer_listings(language: @language,
      geolocation: @geolocation, location: @location).paginate(page: params[:page], per_page: 20)

    @map_data = RecruiterExtensions::LanguageStatisticsByLocation.new(
      @language, current_user.developer_listings(language: @language,
        geolocation: @geolocation, location: @location)).perform
  end

  def example
    me = Developer.find_by_login("guiman")
    me.hireable = true
    @developer = DeveloperProfilePresenter.new(
      subject: me,
      viewer: RecruiterUser.new(DevRecruiter.find_by_name('Alvaro Fernando Lara')))
    render :show
  end

  def create
    developer = RecruiterExtensions::BuildDeveloperProfile.new(request.env['omniauth.auth']).perform
    session[:developer_id] = developer.id

    redirect_to developer_profile_path(developer.secure_reference)
  end

  def show
    redirect_to root_path unless @developer_presenter.can_be_displayed?
  end

  def toggle_public
    @developer_presenter.toggle_public

    redirect_to developer_profile_path(@developer_presenter.secure_reference)
  end

  def contact
    current_user.contact_developer(@developer_presenter, message: params.fetch(:body))

    redirect_to root_path
  end

  private

  def build_presenter
    @developer_presenter = DeveloperProfilePresenter.new(
      subject: Developer.find_by_secure_reference(params[:secure_reference]),
      viewer: current_user.user)
  end
end
