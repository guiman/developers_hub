class RecruiterUser
  attr_reader :recruiter

  def initialize(recruiter)
    @recruiter = recruiter
  end

  def can_see_developer?(developer)
    developer.public? || @recruiter.beta_user?
  end

  def logged_in?
    true
  end

  def id
    @recruiter.id
  end

  def name
    @recruiter.name
  end

  def email
    @recruiter.email
  end

  def is_a_recruiter?
    true
  end

  def is_a_beta_recruiter?
    @recruiter.beta_user?
  end

  def is_a_developer?
    false
  end

  def can_make_public?(developer)
    false
  end

  def developers
    @recruiter.developers
  end

  def ==(recruiter)
    @recruiter == recruiter
  end

  def watching?(developer)
    @recruiter.developers.include? developer
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = @recruiter.beta_user? ? Developer.all  : Developer.where(hireable: true)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
