class DeveloperListingPresenter
  def initialize(subject: , viewer: )
    @subject = subject
    @viewer = viewer
  end

  def name
    if @subject.public? || (@viewer.is_a_recruiter? && @viewer.is_a_beta_recruiter?)
      @subject.name
    else
      @subject.obfuscated_name
    end
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
