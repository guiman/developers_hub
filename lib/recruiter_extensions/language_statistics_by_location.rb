require 'geokit'

module RecruiterExtensions
  class LanguageStatisticsByLocation
    def initialize(lang)
      @lang = lang
    end

    @@locations = {}

    def perform
      users = RecruiterExtensions::IndexedUser.all
      users.group_by(&:geolocation)
        .map do |k,v|
          {
            position: k.split(','),
            language: @lang.capitalize,
            language_count: v.select do |candidate|
              candidate.languages.keys
                .map(&:to_s)
                .map(&:downcase)
                .include?(@lang.downcase)
            end.count
          }
        end.select { |each| each.fetch(:position).length == 2 }
    end
  end
end
