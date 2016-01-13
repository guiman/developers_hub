module DeveloperHelper
  def candidate_top_skills(candidate:, top_skill_count:)
    ArchiveClient.dev_skills(github_handle: candidate.login).first(top_skill_count).map do |dev_skill|
      "#{dev_skill.fetch("name")}: #{dev_skill.fetch("prs")}"
    end.join(', ')
  end

  def candidate_top_skills_chart(candidate:, top_skill_count:)
    ArchiveClient.dev_skills(github_handle: candidate.login).first(top_skill_count).map do |dev_skill|
      "['#{dev_skill.fetch("name")}', '#{dev_skill.fetch("prs")}']"
    end.join(', ')
  end
end
