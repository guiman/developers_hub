require 'ohm'
require 'ohm/contrib'

Ohm.redis = Redic.new("redis://127.0.0.1:6379")

class StoredUserInformation < Ohm::Model
  include Ohm::DataTypes

  attribute :user_login
  attribute :org_login
  attribute :commit_count
  attribute :information, Type::Hash

  index :user_login
  index :org_login
end
