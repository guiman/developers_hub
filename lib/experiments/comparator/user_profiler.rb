require_relative 'stored_user_information'

class UserProfiler
  def self.build(user, target_organization=nil, language_whitelist=[], language_blacklist=["Text", nil])

    org_login = target_organization.login if target_organization
    user_information = StoredUserInformation.find(user_login: user.login,
      org_login: org_login).first

    # Calculate and store information
    unless user_information
      commit_count, information = calculate_profile(user, target_organization,
        language_whitelist, language_blacklist)
      user_information = StoredUserInformation.create(user_login: user.login,
        information: information, commit_count: commit_count, org_login: org_login)
    end

    information = user_information.information

    if language_whitelist.any?
      information = user_information.information.
        select { |lang, project_percentage| language_whitelist.include? lang }
    end

    UserProfileInformation.new(user, language_whitelist, language_blacklist,
      user_information.commit_count.to_i, information)
  end

  UserProfileInformation = Struct.new(:user, :language_whitelist, :language_blacklist, :commit_count, :information)

  def self.calculate_profile(user, target_organization=nil, language_whitelist=[], language_blacklist=[])
    # First build a list of repositories to analize
    repos = user.repositories

    user_organizations = user.organization_list || []

    moar_repos = user_organizations.inject([]) do |acc, org|
      repository_type = (target_organization && org.login == target_organization.login) ? 'all' : 'public'
      repositories = org.repositories(repository_type).select do |repository|
        repository.commits(user.login).any?
      end

      acc.concat repositories
      acc
    end

    repos.concat moar_repos

    # Now ask for the language analysis to Recruiter
    overall_language_data = user.languages_2(repos)

    # This is the point where we start calculating information
    languages = overall_language_data.fetch(:languages_breakdown)

    overall_language_data_count = overall_language_data.fetch(:analyzed_file_count)

    result = languages.inject({}) do |acc, (lang, count)|
      unless language_blacklist.include?(lang)
        project_percentage = count.to_f / overall_language_data_count.to_f * 100.0
        acc[lang] = project_percentage
      end

      acc
    end.select { |language, project_percentage| project_percentage > 1 }

    [overall_language_data_count, result]
  end
end
