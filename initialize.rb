require 'bundler'
Bundler.require

extension_lib = File.join(__dir__, 'lib')
$:.unshift(extension_lib) unless $:.include?(extension_lib)

require 'recruiter'
require 'recruiter/cached_search_strategy'
require 'omniauth'
require 'better_errors'

require 'active_record'
require_relative 'database'
require_relative 'developer_profile/app'
require 'recruiter_extensions'

Geokit::Geocoders::MapboxGeocoder.key = 'pk.eyJ1IjoiYWx2YXJvbGEiLCJhIjoicjkxUGpONCJ9.lYnv1rHrMRVzy5r5PM5ivg'

# Setup Faraday to use cache and so Octokit becomes faster
stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, shared_cache: false, serializer: Marshal
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Octokit.middleware = stack
