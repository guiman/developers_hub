class DevelopersController < ApplicationController
  before_action :build_presenter, only: [:show, :toggle_public, :contact, :watch, :update_data]

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

  def create_profile
    redirect_to root_path unless current_user.logged_in? && current_user.is_a_recruiter? && current_user.recruiter.beta_user?

    if @developer = RecruiterExtensions::DeveloperProfile.create(github_login: params[:github_login])
      redirect_to developer_profile_path(@developer.secure_reference)
    end
  end

  def create
    developer = RecruiterExtensions::BuildDeveloperProfile.new(request.env['omniauth.auth']).perform
    session[:developer_id] = developer.id
    flash[:welcome] = "Welcome! We will make sure your profile is up to date. It should be finish in a couple minutes!"

    redirect_to developer_profile_path(developer.secure_reference)
  end

  def show
    if @developer_presenter.developer_skills.count == 0
      flash[:missing_skills] = "Oops, looks like we had trouble processing this Developer's skills. Please try again later, or contact me at alvaro at dev-hub.io"
    end
    redirect_to root_path unless @developer_presenter.can_be_displayed?
  end

  def toggle_public
    @developer_presenter.toggle_public

    redirect_to developer_profile_path(@developer_presenter.secure_reference)
  end

  def watch
    redirect_to root_path unless @developer_presenter.viewer.is_a_beta_recruiter?

    if @developer_presenter.watching?
      @developer_presenter.viewer.developers.delete(@developer_presenter.developer)
    else
      @developer_presenter.viewer.developers << @developer_presenter.developer
      flash[:watched] = "Great! See all the developer you are watching"
    end

    redirect_to developer_profile_path(@developer_presenter.secure_reference)
  end

  def update_data
    redirect_to root_path unless @developer_presenter.viewer.is_a_beta_recruiter?

    DeveloperUpdaterWorker.perform_async(@developer_presenter.login, {
      parse_activity: true, parse_contributions: true })

    redirect_to developer_profile_path(@developer_presenter.secure_reference)
  end

  private

  def build_presenter
    developer = Developer.find_by_secure_reference(params[:secure_reference])

    redirect_to root_path unless developer.present?
    @developer_presenter = DeveloperProfilePresenter.new(
      subject: developer,
      viewer: current_user.user)
  end
end
