require_relative 'initialize'
require 'json'
require 'geokit'

Geokit::Geocoders::MapboxGeocoder.key = 'pk.eyJ1IjoiYWx2YXJvbGEiLCJhIjoicjkxUGpONCJ9.lYnv1rHrMRVzy5r5PM5ivg'

class RecruiterApp < Sinatra::Base
  configure do
    set :server, :thin
    set :bind, '0.0.0.0'
  end

  get '/' do
    @candidates = RecruiterExtensions::IndexedUser.all

    erb :index
  end

  get '/map/:lang' do
    @lang = params.fetch("lang", "no-lang")
    erb :map
  end

  get '/map_data/:lang' do
    content_type :json

    RecruiterExtensions::LanguageStatisticsByLocation.new(params.fetch("lang", "no-lang")).perform.to_json
  end

  get '/by_coordinates/:lang/:lat/:lng' do
    pair = "#{params.fetch("lat")},#{params.fetch("lng")}"
    lang = params.fetch("lang", "no-lang")

    @candidates = RecruiterExtensions::IndexedUser.where(geolocation: pair).all
    @candidates = (lang == "no-lang") ? @candidates : @candidates.select do |candidate|
        candidate.languages.keys.map(&:to_s).map(&:downcase).include?(lang)
      end
    erb :index
  end

  get '/generate_index' do
    search = Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy)
      .at("Chichester, UK")
      .and_at("Brighton, UK")

    RecruiterExtensions::GithubSearchIndexUpdater.new(search.all).perform

    redirect '/'
  end
end

