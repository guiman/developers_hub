require_relative 'initialize'

class RecruiterApp < Sinatra::Base
  get '/' do
    @candidates = RecruiterExtensions::IndexedUser.all

    erb :index
  end

  get '/generate_index' do
    search = Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy)
      .at("Portsmouth")
      .and_at("Southampton")
      .and_at("Winchester")
      .and_at("Hampshire")
      .skills("Ruby,Javascript")

    candidates = search.all.select do |candidate|
      languages = candidate.skills.top(3)
      (candidate.location.include?("UK") || candidate.location.include?("southampton") ||candidate.location.include?("England")) && ((languages.include?(:Ruby) || languages.include?(:JavaScript)))
    end

    RecruiterExtensions::GithubSearchIndexUpdater.new(candidates).perform

    redirect '/'
  end
end

