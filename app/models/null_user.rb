class NullUser
  def logged_in?
    false
  end

  def can_see_developer?(developer)
    developer.public?
  end


  def is_a_developer?
    false
  end

  def is_a_recruiter?
    false
  end

  def method_missing(*args, &block)
    self
  end

  def can_make_public?(developer)
    false
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = Developer.where(hireable: true)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
