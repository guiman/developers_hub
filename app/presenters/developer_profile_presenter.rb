class DeveloperProfilePresenter
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

  def can_be_displayed?
    @developer.hireable? || @viewer.can_see_developer?(@developer)
  end

  def method_missing(method, *args, &block)
    @developer.public_send(method)
  end
end
