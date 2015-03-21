require_relative 'initialize'
require 'json'
require 'geokit'

class RecruiterApp < Sinatra::Base
  get '/' do
    @candidates = RecruiterExtensions::IndexedUser.where(hireable: true).order(:name).all

    erb :index
  end

  get '/map_data/:lang' do
    content_type :json

    RecruiterExtensions::LanguageStatisticsByLocation.new(params.fetch("lang", "all")).perform.to_json
  end

  get '/:lang' do
    @lang = params.fetch("lang", "all")
    @candidates = RecruiterExtensions::IndexedUser.where(hireable: true).order(:name).all
    @candidates = (@lang == "all") ? @candidates : @candidates.select do |candidate|
        candidate.languages.keys.map(&:to_s).map(&:downcase).include?(@lang)
      end

    erb :map
  end

  get '/:lang/:lat/:lng' do
    pair = "#{params.fetch("lat")},#{params.fetch("lng")}"
    @lang = params.fetch("lang", "all")

    @candidates = RecruiterExtensions::IndexedUser.where(geolocation: pair).where(hireable: true).order(:name).all
    @candidates = (@lang == "all") ? @candidates : @candidates.select do |candidate|
        candidate.languages.keys.map(&:to_s).map(&:downcase).include?(@lang)
      end
    erb :map
  end
end
