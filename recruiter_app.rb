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
    Recruiter.search.at("Portsmouth").and_at("Southampton").with_repos('>5').skills("Ruby,Javascript").all.slice(1..10).map(&:to_hash).to_json
  end
end

