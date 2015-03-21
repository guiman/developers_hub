require_relative 'initialize'
require 'json'
require 'geokit'

class RecruiterApp < Sinatra::Base
  get '/' do
    @candidates = RecruiterExtensions::IndexedUser.where(hireable: true).order(:name).all

    erb :index
  end

  # JSON map data for particular languages
  get '/map_data/:lang' do
    content_type :json

    RecruiterExtensions::LanguageStatisticsByLocation.new(params.fetch("lang", "all")).perform.to_json
  end

  ### Filters
  # By location
  get '/location/:location' do
    @location = params.fetch("location", "all")
    @language = params.fetch("language", "all")
    @candidates = RecruiterExtensions::FilterIndexedUsers.new(
      location: @location).all

    erb :map
  end

  # By language
  get '/lang/:language' do
    @language= params.fetch("language", "all")
    @candidates = RecruiterExtensions::FilterIndexedUsers.new(
      language: @language).all

    erb :map
  end

  # By location and language
  get '/lang/:language' do
    @location = params.fetch("location", "all")
    @language = params.fetch("language", "all")
    @candidates = RecruiterExtensions::FilterIndexedUsers.new(
      location: @location, language: @language).all

    erb :map
  end

  # By language and geolocation
  get '/:lat/:lng/:language' do
    pair = "#{params.fetch("lat")},#{params.fetch("lng")}"
    @language = params.fetch("language", "all")

    @candidates = RecruiterExtensions::FilterIndexedUsers.new(
      language: @language, geolocation: pair).all

    erb :map
  end
end
