require 'descriptive_statistics'
require_relative 'user_profiler'

class Comparator
  def compare_against_collection(user, collection, target_organization=nil, language_whitelist=[])
    results = collection.map do |member|
      compare_two_users(user, member, target_organization, language_whitelist)
    end

    results.select { |x| x.user_b_commits > 2 }.
      sort_by { |x| x.difference_vector.standard_deviation }
  end

  def compare_two_users(user_a, user_b, target_organization=nil, language_whitelist=[])
    user_a_profile = UserProfiler.build(user_a, target_organization, language_whitelist)
    user_b_profile = UserProfiler.build(user_b, target_organization, language_whitelist)

    user_a_data = user_a_profile.information
    user_b_data = user_b_profile.information

    compared_languages = (user_a_data.keys | user_b_data.keys).uniq

    user_a_projects = compared_languages.inject({}) do |acc, language|
      acc[language] = user_a_data.fetch(language, 0.0)
      acc
    end

    user_b_projects = compared_languages.inject({}) do |acc, language|
      acc[language] = user_b_data.fetch(language, 0.0)
      acc
    end

    difference_vector = compared_languages.map do |language|
      (user_a_projects.fetch(language, 0.0) - user_b_projects.fetch(language, 0.0)).abs
    end

    ComparisonReport.new(user_a, user_b, difference_vector, compared_languages,
      user_a_projects, user_b_projects, user_a_profile.commit_count, user_b_profile.commit_count)
  end

  ComparisonReport = Struct.new(:user_a, :user_b, :difference_vector,
    :compared_languages, :user_a_projects, :user_b_projects, :user_a_commits, :user_b_commits)
end
