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

  def id
    @recruiter.id
  end

  def can_see_instructions?
    @viewer.is_a_recruiter? && @viewer.recruiter == @recruiter
  end

  def can_see_following?
    @viewer.is_a_recruiter? && @viewer.recruiter == @recruiter
  end

  def following
    @recruiter.developers
  end
end
