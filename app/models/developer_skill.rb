class DeveloperSkill < ActiveRecord::Base
  belongs_to :developer, counter_cache: true
  belongs_to :skill

  validates :developer, presence: true
  validates :skill, presence: true

  # Create set of skills using candidate languages as origin
  def self.create_from_candidate(developer:, candidate:)
    candidate.languages.each do |language, repos|
      repos = repos.map(&:symbolize_keys)
      skill = Skill.find_or_create_by(name: language.to_s)
      sorted_repos = repos.sort { |a,b| b[:popularity] <=> a[:popularity] }
      top_skill_repo = sorted_repos.detect { |repo| repo.fetch(:main_language).to_s == language.to_s }

      # Only take in consideration relevant skills
      if !top_skill_repo.nil? && (repos.count >= 2 || top_skill_repo.fetch(:popularity) >= 3)
        dev_skill = DeveloperSkill.find_or_initialize_by(skill_id: skill.id, developer_id: developer.id)
        dev_skill.code_example = top_skill_repo.fetch(:name)
        dev_skill.strength = repos.count
        dev_skill.save
      end
    end
  end
end
