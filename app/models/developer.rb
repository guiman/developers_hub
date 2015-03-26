class Developer < ActiveRecord::Base
  serialize :languages
  before_create :set_secure_reference

  def self.create_from_auth_hash(auth)
    user = self.create(uid: auth.uid,
                       token: auth.credentials.token,
                       login: auth.extra.raw_info.login)
    user
  end

  def obfuscated_name
    adjectives = ["ninja", "guru", "evangelist", "pope", "samurai", "prophet", "hacker"]
    "#{sorted_languages.keys.first.to_s} #{adjectives.sample}"
  end

  def sorted_languages
    languages.sort {|a,b| b[1] <=> a[1] }.to_h
  end

  def ==(another_object)
    login == another_object.login
  end

  def set_secure_reference
    self.secure_reference = SecureRandom.hex(10)
  end
end
