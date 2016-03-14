class Developer < ActiveRecord::Base
  serialize :languages

  has_many :developer_skills
  has_many :skills, through: :developer_skills

  has_many :developer_wacther, dependent: :destroy
  has_many :watching, through: :developer_watcher

  before_create :set_secure_reference

  def self.create_from_auth_hash(auth)
    self.create(uid: auth.uid,
                token: auth.credentials.token,
                login: auth.extra.raw_info.login)
  end

  def update_from_auth_hash(auth)
    self.update_attributes(uid: auth.uid,
      token: auth.credentials.token,
      login: auth.extra.raw_info.login)
  end

  def ==(another_object)
    login == another_object.login
  end

  def set_secure_reference
    self.secure_reference = SecureRandom.hex(10)
  end

  # Obfuscation when showing to non allowed viewers
  def obfuscated_name
    dev_skill = developer_skills.order(strength: :desc).first
    skill = (dev_skill) ? dev_skill.skill.name.to_s : 'OpenSource'
    "#{skill} dev"
  end

  def blurred_gravatar_url
    image = Dragonfly.app.fetch_url(self.gravatar_url)
    image.convert('-blur 15x15').url
  end
end
