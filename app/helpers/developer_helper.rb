module DeveloperHelper
  def candidate_top_skills(candidate:, top:)
    candidate.developer_skills.where(origin: 'github').order(strength: :desc).limit(top).map do |dev_skill|
      "#{dev_skill.skill.name}: #{dev_skill.strength}"
    end.join(', ')
  end

  def link_to_code_example(developer_skill)
    github_login = developer_skill.developer.login
    project_name = developer_skill.code_example.gsub(/\A#{github_login}\//, '')
    "https://github.com/#{github_login}/#{project_name}"
  end
end
