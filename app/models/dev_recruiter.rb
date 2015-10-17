class DevRecruiter < ActiveRecord::Base
  has_many :developer_watchers, dependent: :destroy
  has_many :developers, through: :developer_watchers

  def ==(other)
    self.uid == other.uid
  end
end
