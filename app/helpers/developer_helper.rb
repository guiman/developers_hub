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

  def link_to_current_search(developer=nil)
    current_search = session.fetch("current_search", {})
    location = current_search.fetch("location", nil)
    languages = current_search.fetch("languages", "")
    page = current_search.fetch("page", nil)

    link_to "Back to search", search_path(location: location, languages: languages, page: page, highlight_developer: developer), class: "button"
  end

  def show_back_to_search?
    session.fetch("current_search", {}).fetch("location", nil).present? ||
      session.fetch("current_search", {}).fetch("languages", nil).present?
  end
end
