class CurrentUser
  attr_reader :user

  def self.from_session(developer_id: , recruiter_id:)
    user = if developer_id
      DeveloperUser.new(Developer.find(developer_id))
    elsif recruiter_id
      RecruiterUser.new(DevRecruiter.find(recruiter_id))
    else
      NullUser.new
    end

    new(user)
  end

  def initialize(user)
    @user = user
  end

  def is_a_developer?
    @user.instance_of? DeveloperUser
  end

  def is_a_recruiter?
    @user.instance_of? RecruiterUser
  end

  def method_missing(name, *args, &block)
    @user.public_send(name, *args)
  end
end
