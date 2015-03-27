class CurrentUser
  def self.from_session(developer_id: , recruiter_id: '')
    if developer_id
      DeveloperUser.new(Developer.find(developer_id))
    elsif recruiter_id
      RecruiterUser.new(DevRecruiter.find(recruiter_id))
    else
      DeveloperUser.new(NullDeveloper.new)
    end
  end
end
