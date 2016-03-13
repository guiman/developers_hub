class GeolocationAdapter
  def self.coordinates_based_on_address(address)
    Geokit::Geocoders::MapboxGeocoder.geocode(address).ll
  end
end
