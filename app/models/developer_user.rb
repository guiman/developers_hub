class DeveloperUser
  attr_reader :developer

  def initialize(developer)
    @developer = developer
  end

  def secure_reference
    @developer.secure_reference
  end

  def logged_in?
    !@developer.instance_of? NullDeveloper
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = Developer.where(hireable: true).order(:name)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
