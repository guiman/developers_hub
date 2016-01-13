require 'rest-client'

class ArchiveClient
  def self.dev_skills(github_handle:)
    response = JSON.parse(RestClient.get("archive-observer.herokuapp.com/api/user/#{github_handle}"))
    response.fetch("user").fetch("stats").fetch("languages")
  rescue RestClient::ExceptionWithResponse
    []
  end
end
