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

  def is_a_developer?
    false
  end

  def can_make_public?(developer)
    false
  end


  def ==(recruiter)
    @recruiter == recruiter
  end

  def contact_developer(developer_profile_presenter, message:)
    if developer_profile_presenter.can_be_contacted?
      Offer.create(developer: developer_profile_presenter.developer, dev_recruiter: developer_profile_presenter.viewer.recruiter)
      OfferMailer.new_offer(developer_profile_presenter, message).deliver_now
    end
  end

  def developer_listings(language: 'all', location: 'all', geolocation: 'all')
    developers = @recruiter.beta_user? ? Developer.all  : Developer.where(hireable: true)
    RecruiterExtensions::FilterDevelopers.new(developers: developers,
      language: language, location: location, geolocation: geolocation).all
  end
end
