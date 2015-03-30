require 'rails_helper'

describe DeveloperUser do
  describe "#logged_in?" do
    it "returns true" do
      expect(described_class.new(nil).logged_in?).to eq(true)
    end
  end

  describe "#can_see_developer?" do
    it "return true when is the same developer" do
      dev = Developer.create(login: "test1", hireable: true)
      Developer.create(login: "test2", hireable: true)
      expect(described_class.new(dev).can_see_developer?(dev)).to eq(true)
    end

    it "return false for other developers" do
      dev = Developer.create(login: "test1", hireable: true)
      dev_2 = Developer.create(login: "test2", hireable: true)
      expect(described_class.new(dev).can_see_developer?(dev_2)).to eq(false)
    end
  end

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
      skills = [ Skill.create(name: "C"), Skill.create(name: "Java"), Skill.create(name: "Ruby"), Skill.create(name: "R")]

      dev = Developer.create(login: "test1", hireable: true)
      DeveloperSkill.create(developer: dev, skill: skills[3], strength: 3)

      DeveloperSkill.create(developer: Developer.create(login: "test2", hireable: true),
                            skill: skills[0], strength: 3)
      DeveloperSkill.create(developer: Developer.create(login: "test3", hireable: true),
                            skill: skills[1], strength: 3)
      DeveloperSkill.create(developer: Developer.create(login: "test4", hireable: true),
                            skill: skills[2], strength: 3)
      DeveloperSkill.create(developer: Developer.create(login: "test5", hireable: false),
                            skill: skills[1], strength: 3)

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
