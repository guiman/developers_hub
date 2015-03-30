require 'rails_helper'

describe RecruiterExtensions::LanguageStatisticsByLocation do
  it "returns an array of locations" do
    southampton_coords = "50.90970040000001, -1.4043509"
    portsmouth_coords = "50.816667, -1.083333"

    allow(Geokit::Geocoders::MapboxGeocoder).to receive(:geocode).with("Southampton, Hampshire, UK").and_return(southampton_coords)
    allow(Geokit::Geocoders::MapboxGeocoder).to receive(:geocode).with("Portsmouth, UK").and_return(portsmouth_coords)

    ruby = Skill.create(name: "Ruby")

    DeveloperSkill.create(developer: Developer.create(login: "user1", hireable: true,
      location: "Southampton, Hampshire, UK",
      geolocation: southampton_coords),
      skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(login: "user2", hireable: true,
      location: "Portsmouth, UK",
      geolocation: portsmouth_coords),
      skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(login: "user3", hireable: true,
      location: "Portsmouth, UK",
      geolocation: portsmouth_coords),
      skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(login: "user4", hireable: true,
      location: "Portsmouth, UK",
      geolocation: portsmouth_coords),
      skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(login: "user5", hireable: false,
      location: "Portsmouth, UK",
      geolocation: portsmouth_coords),
      skill: ruby, strength: 3)

    statistics = described_class.new("ruby")

    expect(statistics.perform).to match_array(
     [
      { position: southampton_coords.split(','), language: "Ruby", language_count: 1 },
      { position: portsmouth_coords.split(','), language: "Ruby", language_count: 3 },
    ])
  end
end
