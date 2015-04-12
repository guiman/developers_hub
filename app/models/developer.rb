class Developer < ActiveRecord::Base
  serialize :languages
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
end
