class RecruiterUser
  def initialize(recruiter)
    @recruiter = recruiter
  end

  def logged_in?
    true
  end

  def developer
    nil
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = Developer.where(hireable: true).order(:name)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
