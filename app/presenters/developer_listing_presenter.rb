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

  def self.cast(candidates, viewer:)
    candidates.select do |candidate|
      !candidate.skills.empty?
    end.map do |candidate|
      DeveloperListingPresenter.new(subject: candidate, viewer: viewer.user)
    end
  end
end
