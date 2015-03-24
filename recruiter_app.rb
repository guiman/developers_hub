require_relative 'initialize'
require 'json'
require 'geokit'

class RecruiterApp < Sinatra::Base
  configure do
    set :public_folder, File.dirname(__FILE__) + '/static'
  end

  get '/' do
    @candidates = RecruiterExtensions::FilterIndexedUsers.new.all

    erb :index
  end

  get '/candidates' do
    content_type :json

    RecruiterExtensions::FilterIndexedUsers.new.all.to_json
  end

  get '/subscribe' do
    erb :subscribe
  end

  post '/subscribe' do
    email = params.fetch("email")

    if RecruiterExtensions::Subscriber.create(email: email)
      redirect '/'
    else
      erb :subscribe
    end
  end

  get '/user/:id' do
    begin
      @id = params.fetch("id")
      @user = RecruiterExtensions::IndexedUser.find(@id)
      erb :user
    rescue ActiveRecord::RecordNotFound
      redirect '/'
    end
  end

  # JSON map data for particular languages
  get '/map_data/:lang' do
    content_type :json

    RecruiterExtensions::LanguageStatisticsByLocation.new(
      params.fetch("lang", "all")).perform.to_json
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
