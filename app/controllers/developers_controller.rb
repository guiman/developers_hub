class DevelopersController < ApplicationController
  def index
    @candidates = RecruiterExtensions::FilterDevelopers.new.all
  end

  def filter
    @location = params.fetch("location", "all")
    @language = params.fetch("language", "all")
    lat = params["lat"]
    lng = params["lng"]
    @geolocation = (lat && lng) ? "#{lat},#{lng}" : 'all'

    @candidates = RecruiterExtensions::FilterDevelopers.new(
      language: @language, geolocation: @geolocation, location: @location).all
  end


  def map_data
    data = RecruiterExtensions::LanguageStatisticsByLocation.new(
      params.fetch("lang", "all")).perform

    render json: data
  end

  def show
    @user = Developer.find_by_secure_reference(params[:secure_reference])
    redirect_to root_path unless @user.hireable
  end
end
