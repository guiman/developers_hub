class Experiments::ComparatorController < ApplicationController
  layout 'experiments_layout'

  def reduce_skills
    @user_list = params[:users].split(',')

    @results = @user_list.map do |user|
      begin
        caching_method = Recruiter::RedisCache.new(settings.redis_client)
        candidate = Recruiter::GithubCandidate.new(settings.recruiter_client.user(user),
          settings.recruiter_client)
        cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)

        UserProfiler.build(cached_candidate)
      rescue Octokit::NotFound
      end
    end.compact

    languages = @results.map { |res| res.information.keys }.inject(:&)

    languages_reduction = languages.inject({}) do |acc, lang|
      language_for_all_users = @results.map { |res| res.information.fetch(lang) }
      acc[lang] = language_for_all_users.mean
      acc
    end

    @language_reduction_datasets = [{
      label: "Language Reduction",
      fillColor: "rgba(220,220,220,0.5)",
      strokeColor: "rgba(220,220,220,0.8)",
      highlightFill: "rgba(220,220,220,0.75)",
      highlightStroke: "rgba(220,220,220,1)",
      data: languages_reduction.values
    }].to_json

    @raw_dataset_information = @results.map do |res|
      data = languages.map { |lang| res.information.fetch(lang, 0.0).to_s }
      random_color = ->() { (100..220).step(30).to_a.sample }
      rgb_colours = "#{random_color.call},#{random_color.call},#{random_color.call}"
      colour = "rgba(#{rgb_colours},1)"

      {
        label: res.user.login,
        fillColor: "rgba(#{rgb_colours},0.2)",
        strokeColor: colour,
        pointColor: colour,
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: colour,
        data: data
      }
    end

    @languages_labels = languages.to_json
    @dataset_information = @raw_dataset_information.to_json
  end


  def compare_against_search
    @results = CompareAgainstSearch.perform(Comparator.new, settings.recruiter_client,
      settings.redis_client, params[:user], location: params["location"],
      skills: params["skills"], hireable: params["hireable"])

    @message = "People from #{params.fetch("location", 'Anywhere')} with #{params.fetch("skills", 'some')} skills that are similar to #{params[:user]}"

    erb :comparison
  end

  def compare_against_other_user
    languages_to_compare = params.fetch("languages", "").split(",")
    @result = CompareAgainstUser.perform(Comparator.new, settings.recruiter_client,
      settings.redis_client, params[:user], params[:other_user], languages_to_compare)

    @languages_labels = @result.compared_languages.map { |x| "\"#{x.to_s}\"" }.join(",")
    @user_languages_vector = @result.user_a_projects.values
    @other_user_languages_vector = @result.user_b_projects.values

    erb :user_comparison
  end

  def compare_against_org
    languages_to_compare = params.fetch("languages", "").split(",")
    @results = CompareAgainstOrg.perform(Comparator.new, settings.recruiter_client,
      settings.redis_client, params[:user], params[:org], languages_to_compare)

    @message = "People working at #{params[:org]} that are similar to #{params[:user]}"

    erb :comparison
  end

  def compare_against_following
    @results = CompareAgainstFollowing.perform(Comparator.new,
      settings.recruiter_client, settings.redis_client, params[:user])

    @message = "People #{params[:user]} is following, against himself"

    erb :comparison
  end

  private

  def settings
    ExperimentConfiguration
  end
end
