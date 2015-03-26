class DeveloperUser
  def self.from_session(user_id)
    if user_id.nil?
      self.new(NullDeveloper.new)
    else
      self.new(Developer.find(user_id))
    end
  end

  attr_reader :developer

  def initialize(developer)
    @developer = developer
  end

  def secure_reference
    @developer.secure_reference
  end

  def logged_in?
    !@developer.instance_of? NullDeveloper
  end
end
