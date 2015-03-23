require 'active_record'

module RecruiterExtensions
  class IndexedUser < ActiveRecord::Base
    serialize :languages

    def obfuscated_name
      names  = name.split(' ')
      surname = names.pop
      replacement_lenth = surname.size - 5 % surname.size
      to_be_replaced = surname.slice(surname.size - replacement_lenth, surname.size)
      surname = surname.sub(to_be_replaced, '*' * replacement_lenth)
      names.push(surname).join ' '
    end

    def sorted_languages
      languages.sort {|a,b| b[1] <=> a[1] }.to_h
    end

    def ==(another_object)
      login == another_object.login
    end
  end
end
