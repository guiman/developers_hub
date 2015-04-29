module RecruiterExtensions
  class FilterDevelopers

    def initialize(developers: nil, location: 'all', language: 'all', geolocation: 'all')
      @location = location
      @language = language
      @geolocation = geolocation
      @developers = (developers.nil?) ? Developer.where(hireable: true) : developers
    end

    def all
      candidates = @developers
      candidates = (@geolocation == "all") ? candidates : candidates.where(geolocation: @geolocation)
      candidates = (@location == "all") ? candidates : candidates.where("location LIKE ?", "%#{@location}%")
      candidates = (@language == "all") ? candidates : candidates.joins(:skills).where(skills: { name: @language })

      if (@language == "all")
        candidates = candidates.joins(:skills).where(developer_skills: { origin: 'github' }).order(developer_skills_count: :desc)
      else
        candidates = candidates.joins(:skills).where(skills: { name: @language }).where(developer_skills: { origin: 'github' }).order('developer_skills.strength DESC')
      end

      candidates.distinct
    end
  end
end
