require 'geokit'

module RecruiterExtensions
  class LanguageStatisticsByLocation
    def initialize(lang, developers=nil)
      @lang = lang
      @developers = developers.nil? ? Developer.where(hireable: true) : developers
    end

    def perform
      users_with_language = (@lang == "all") ? @developers : @developers.select do |candidate|
        candidate.skills
        .map(&:name)
        .map(&:to_s)
        .map(&:downcase)
        .include?(@lang.downcase)
      end

      users_with_language.group_by(&:geolocation).map do |k,v|
        {
          position: k.split(','),
          location: v.first.location,
          language: @lang.capitalize,
          language_count: v.count
        }
      end
    end
  end
end
