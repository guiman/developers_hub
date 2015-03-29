class DevRecruiter < ActiveRecord::Base
  def ==(other)
    self.uid == other.uid
  end
end
