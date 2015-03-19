require 'active_record'

module RecruiterExtensions
  class IndexedUser < ActiveRecord::Base
    serialize :languages

    def ==(another_object)
      login == another_object.login
    end

    def standarized_location
      # remove repeated spaces
      address_parts = location.split.join(' ')

      if address_parts.split(',').count >= 2
        # Southmapton, hampshire
        address_parts = address_parts.split(',')
      else
        # Southmapton hampshire
        address_parts = address_parts.split(' ')
      end

      # Southmapton hampshire uk
      if address_parts.count > 2
        address_parts = address_parts.first(2)
      end

      address_parts = address_parts.map { |address_part| address_part.gsub(/ /, '') }.join(',')

      # hampshire,uk
      address_parts.downcase.gsub(/england/, 'uk').gsub(/unitedkingdom/, 'uk')
    end
  end
end
