class Developer < ActiveRecord::Base
  serialize :languages
  serialize :activity, Array

  has_many :developer_skills
  has_many :skills, through: :developer_skills

  before_create :set_secure_reference

  def self.create_from_auth_hash(auth)
    user = self.create(uid: auth.uid,
                       token: auth.credentials.token,
                       login: auth.extra.raw_info.login)
    user
  end

  def update_from_auth_hash(auth)
    self.update_attributes(uid: auth.uid,
      token: auth.credentials.token,
      login: auth.extra.raw_info.login)
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

  def linkedin_profile
    @linkedin_profile ||= RecruiterExtensions::LinkedinProfile.new(login)
  end

  def find_linkedin_profile
    return unless linkedin_profile.verify_link

    linkedin_profile.link
  end

  def activity_for_chart
    result = {}
    from = Date.today - 3.month
    to = Date.today

    (from..to).step(7) do |week|
      current_range = ((week - 1.week)..week)

      activity_found = activity.select do |act|
        current_range.include?(act.fetch(:updated_at).to_date)
      end.count

      result[week] = activity_found
    end

    # We need to group activity by date
    real_dates = result.keys
    real_dates.map! { |d| "'#{d.strftime('%Y-%m-%d')}'".html_safe }
    real_dates.prepend('\'x\''.html_safe)

    activity_data = result.values

    activity_data.prepend('\'activity\''.html_safe)

    "[#{real_dates.join(',')}], [#{activity_data.join(',')}]"
  end
end
