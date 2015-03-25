class Subscriber < ActiveRecord::Base
  validates :email, presence: true
  validate :valid_email

  def valid_email
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "not a valid email")
    end
  end
end
