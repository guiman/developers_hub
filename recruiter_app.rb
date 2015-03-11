require 'bundler'
Bundler.require

require 'recruiter'
require 'json'

# Setup Faraday to use cache and so Octokit becomes faster
stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, shared_cache: false, serializer: Marshal
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Octokit.middleware = stack

class RecruiterApp < Sinatra::Base
  get '/' do
    @search = Recruiter.search(cached: true).at("Portsmouth").and_at("Southampton").and_at("Winchester").with_repos('>5').skills("Ruby,Javascript")
    candidates = @search.all.slice(1..20)
    @candidates = candidates.select { |candidate| candidate.hireable && (candidate.languages.keys.include?(:Ruby) || candidate.languages.keys.include?(:JavaScript)) }
    erb :index
  end
end

