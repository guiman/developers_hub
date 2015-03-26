namespace :geolocations do
  desc "Fix geolocations"
  task fix_missing: :environment do
    Geokit::Geocoders::MapboxGeocoder.key = 'pk.eyJ1IjoiYWx2YXJvbGEiLCJhIjoicjkxUGpONCJ9.lYnv1rHrMRVzy5r5PM5ivg'
    users_with_faulty_geolocation = Developer.where(geolocation: ",")
    users_with_faulty_geolocation.each do |user|
      user.update(geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(user.location.gsub(/\;/, ' ')).ll)
    end
  end
end
