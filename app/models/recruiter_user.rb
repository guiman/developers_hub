class RecruiterUser
  attr_reader :recruiter

  def initialize(recruiter)
    @recruiter = recruiter
  end

  def can_see_developer?(other_developer)
    false
  end

  def logged_in?
    true
  end

  def id
    @recruiter.id
  end

  def is_a_recruiter?
    true
  end

  def is_a_developer?
    false
  end

  def ==(recruiter)
    @recruiter == recruiter
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = Developer.where(hireable: true).order(:name)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
