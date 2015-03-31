class RecruiterProfilePresenter
  def initialize(subject: , viewer: )
    @recruiter = subject
    @viewer = viewer
  end

  def name
    @recruiter.name
  end

  def email
    @recruiter.email
  end

  def location
    @recruiter.location
  end

  def avatar
    @recruiter.avatar_url
  end
end
