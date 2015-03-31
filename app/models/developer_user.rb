class DeveloperUser
  attr_reader :developer

  def initialize(developer)
    @developer = developer
  end

  def secure_reference
    @developer.secure_reference
  end

  def logged_in?
    true
  end

  def is_a_developer?
    true
  end

  def is_a_recruiter?
    false
  end

  def can_see_developer?(other_developer)
    @developer == other_developer
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = Developer.where(hireable: true).order(:name)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
