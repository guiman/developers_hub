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
      candidates = (@location == "all") ? candidates : candidates.where("location LIKE ?", "%#{@location}%").all
      candidates = (@language == "all") ? candidates : candidates.joins(:skills).where(skills: { name: @language })

      candidates
    end

    def sorted_by_skills
      candidates = self.all
      if (@language == "all")
        candidates = candidates.joins('left join developer_skills on developers.id = developer_skills.developer_id').select("developers.*, count(developer_skills.id) as skill_count").group('developers.id').order('skill_count desc')
      else
        candidates = candidates.joins(:skills).where(skills: { name: @language }).order('developer_skills.strength DESC')
      end

      candidates
    end
  end
end
