require 'active_record'

module RecruiterExtensions
  class IndexedUser < ActiveRecord::Base
    serialize :languages

    def sorted_languages
      languages.sort {|a,b| b[1] <=> a[1] }.to_h
    end

    def ==(another_object)
      login == another_object.login
    end
  end
end
