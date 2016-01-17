require 'rest-client'

class ArchiveClient
  def self.dev_stats(github_handle:, year_to_display: Time.now.year)
    response = JSON.parse(RestClient.get("http://archive-observer.herokuapp.com/api/user/#{github_handle}?year=#{year_to_display}"))
    response.fetch("user").fetch("stats")
  rescue RestClient::ExceptionWithResponse
    {}
  rescue StandardError
    {}
  end
end
