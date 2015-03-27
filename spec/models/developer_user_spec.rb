require 'rails_helper'

describe DeveloperUser do
  describe "#developer_listings" do
    it "shows all hireable developers" do
      dev = Developer.create(login: "test1", hireable: true)
      Developer.create(login: "test2", hireable: true)
      Developer.create(login: "test3", hireable: true)
      Developer.create(login: "test4", hireable: false)

      developer_user = described_class.new(dev.id)
      expect(developer_user.developer_listings.count).to eq(3)
    end

    it "can filter by language" do
      dev = Developer.create(login: "test1", hireable: true, languages: { R: 3 })
      Developer.create(login: "test2", hireable: true, languages: { C: 3 })
      Developer.create(login: "test3", hireable: true, languages: { Java: 3 })
      Developer.create(login: "test4", hireable: true, languages: { Ruby: 3 })
      Developer.create(login: "test5", hireable: false, languages: { Ruby: 3 })

      developer_user = described_class.new(dev.id)
      expect(developer_user.developer_listings(language: 'ruby').count).to eq(1)
    end

    it "can filter by location" do
      dev = Developer.create(login: "test1", hireable: true)
      Developer.create(login: "test2", hireable: true, location: 'uk')
      Developer.create(login: "test3", hireable: true, location: 'uk')
      Developer.create(login: "test4", hireable: true, location: 'uk')
      Developer.create(login: "test5", hireable: false)

      developer_user = described_class.new(dev.id)
      expect(developer_user.developer_listings(location: 'uk').count).to eq(3)
    end

    it "can filter by geolocation" do
      dev = Developer.create(login: "test1", hireable: true)
      Developer.create(login: "test2", hireable: true, geolocation: '1,2')
      Developer.create(login: "test3", hireable: true, geolocation: '1,2')
      Developer.create(login: "test4", hireable: true, geolocation: '1,2')
      Developer.create(login: "test5", hireable: false)

      developer_user = described_class.new(dev.id)
      expect(developer_user.developer_listings(geolocation: '1,2').count).to eq(3)
    end
  end
end
