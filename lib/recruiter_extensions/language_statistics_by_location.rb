require 'geokit'

module RecruiterExtensions
  class LanguageStatisticsByLocation
    def initialize(lang)
      @lang = lang
    end

    def perform
      users = Developer.where(hireable: true)

      users_with_language = (@lang == "all") ? users : users.select do |candidate|
        candidate.languages.keys
        .map(&:to_s)
        .map(&:downcase)
        .include?(@lang.downcase)
      end

      users_with_language.group_by(&:geolocation).map do |k,v|
        {
          position: k.split(','),
          language: @lang.capitalize,
          language_count: v.count
        }
      end
    end
  end
end
