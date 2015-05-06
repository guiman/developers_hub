module RecruiterExtensions
  class SearchDevelopers
    def initialize(languages: [], location: nil, developers: nil)
      @languages = languages.map(&:strip)
      @location = location
      @developers = developers.nil? ? Developer.where(hireable: true) : developers
    end

    def search
      devs = @developers

      if @location.present?
        devs = devs.where("location LIKE ?", "%#{@location}%")
      end

      if @languages.any?
        devs = devs.joins(:skills).where(skills: { name: @languages })
        skills = Skill.where(name: @languages)
        skill_names = skills.map(&:name)
      end

      devs = devs.joins(:skills).where(developer_skills: { origin: 'github' }).order(developer_skills_count: :desc)
      devs = devs.distinct

      if @languages.any?
        devs = devs.select do |dev|
          (skill_names - dev.skills.map(&:name)).empty?
        end
      end

      devs
    end
  end
end
