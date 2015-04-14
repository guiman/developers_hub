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
    adjectives = ["ninja", "guru", "samurai", "hacker", "master"]
    "#{developer_skills.order(strength: :desc).first.skill.name.to_s} #{adjectives.sample}"
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
    pull_request_events.sort { |a,b| a[:created_at] <=> b[:created_at] }
  end
end
