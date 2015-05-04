class Developer < ActiveRecord::Base
  serialize :languages
  serialize :pull_request_events, Array
  serialize :push_events, Array

  has_many :developer_skills
  has_many :skills, through: :developer_skills

  before_create :set_secure_reference

  def self.create_from_auth_hash(auth)
    user = self.create(uid: auth.uid,
                       token: auth.credentials.token,
                       login: auth.extra.raw_info.login)
    user
  end

  def obfuscated_name
    skill = developer_skills.order(strength: :desc).first.skill
    "#{skill.name.to_s} dev"
  end

  def ==(another_object)
    login == another_object.login
  end

  def set_secure_reference
    self.secure_reference = SecureRandom.hex(10)
  end

  def blurred_gravatar_url
    image = Dragonfly.app.fetch_url(self.gravatar_url)
    image.convert('-blur 15x15').url
  end

  def email_is_valid?
    !email.nil? && email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  end

  def commits_pushed
    push_events.map { |event| event.fetch(:commits) }.inject(&:+)
  end

  def pull_requests_opened
    pull_request_events.select { |event| event.fetch(:action) == "opened" && event.fetch(:sender) == login }.count
  end

  def pull_requests_merged
    pull_request_events.select { |event| event.fetch(:action) == "closed" && event.fetch(:merged) && event.fetch(:sender) == login }.count
  end

  def sorted_pull_request_events
    pull_request_events.sort { |a,b| a[:created_at] <=> b[:created_at] }
  end

  def sorted_push_events
    push_events.sort { |a,b| a[:created_at] <=> b[:created_at] }
  end

  def latest_activity_date
    last_push_date = sorted_push_events.last.fetch(:created_at).to_date
    last_pr_date = sorted_pull_request_events.last.fetch(:created_at).to_date

    if last_push_date > last_pr_date
      last_push_date
    else
      last_pr_date
    end
  end

  def linkedin_profile
    @linkedin_profile ||= RecruiterExtensions::LinkedinProfile.new(login)
  end

  def find_linkedin_profile
    return unless linkedin_profile.verify_link

    linkedin_profile.link
  end

  def linkedin_skills
    linkedin_profile.skills
  end

  def education
    linkedin_profile.education
  end

  def experience
    linkedin_profile.experience
  end
end
