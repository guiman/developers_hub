class NullUser
  def logged_in?
    false
  end

  def can_see_developer?(developer)
    false
  end

  def method_missing(*args, &block)
    self
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = Developer.where(hireable: true).order(:name)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
