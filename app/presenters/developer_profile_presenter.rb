class DeveloperProfilePresenter
  attr_reader :developer, :viewer

  def initialize(subject: , viewer: )
    @developer = subject
    @viewer = viewer
  end

  def avatar
    if @viewer.can_see_developer? @developer
      @developer.gravatar_url
    else
      @developer.blurred_gravatar_url
    end
  end

  def name
    if @viewer.can_see_developer? @developer
      @developer.name
    else
      @developer.obfuscated_name
    end
  end

  def toggle_public
    @developer.update_attribute(:public, !@developer.public) if @viewer.can_make_public?(@developer)
  end

  def can_show_toggle_public_link?
    @viewer.can_make_public?(@developer)
  end

  def can_be_displayed?
    @developer.public? || @developer.hireable? || @viewer.can_see_developer?(@developer)
  end

  def can_be_contacted?
    can_be_displayed? && @developer.email_is_valid?
  end

  def can_contact_developer?
    @viewer.is_a_recruiter? && @viewer.can_see_developer?(@developer)
  end

  def method_missing(method, *args, &block)
    @developer.public_send(method)
  end
end
