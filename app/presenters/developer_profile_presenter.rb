class DeveloperProfilePresenter
  def initialize(subject: , viewer: )
    @subject = subject
    @viewer = viewer
  end

  def avatar
    if @viewer == @subject
      @subject.gravatar_url
    else
      @subject.blurred_gravatar_url
    end
  end

  def name
    if @viewer == @subject
      @subject.name
    else
      @subject.obfuscated_name
    end
  end

  def can_be_displayed?
    @subject.hireable? || @subject == @viewer
  end

  def location
    @subject.location
  end

  def hireable
    @subject.hireable
  end


  def sorted_languages
    @subject.sorted_languages
  end
end
