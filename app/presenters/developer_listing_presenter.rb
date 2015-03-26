class DeveloperListingPresenter
  def initialize(subject: , viewer: )
    @subject = subject
    @viewer = viewer
  end

  def name
    @subject.obfuscated_name
  end

  def method_missing(method, *args, &block)
    @subject.public_send(method)
  end
end
