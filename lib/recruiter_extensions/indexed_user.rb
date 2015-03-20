require 'active_record'

module RecruiterExtensions
  class IndexedUser < ActiveRecord::Base
    serialize :languages

    def ==(another_object)
      login == another_object.login
    end
  end
end
