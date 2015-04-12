module RecruiterExtensions
  class FilterIndexedUsers

    def initialize(location: 'all', language: 'all', geolocation: 'all')
      @location = location
      @language = language
      @geolocation = geolocation
    end

    def all
      candidates = IndexedUser.where(hireable: true)
      candidates = (@geolocation == "all") ? candidates : candidates.where(geolocation: @geolocation)
      candidates = (@location == "all") ? candidates : candidates.where("location LIKE ?", "%#{@location}%").all
      candidates = (@language == "all") ? candidates : candidates.select do |candidate|
        candidate.languages.keys.map(&:to_s).map(&:downcase).include?(@language)
      end
    end
  end
end
