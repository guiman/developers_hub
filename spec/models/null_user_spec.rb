require 'rails_helper'

describe NullUser do
  describe "#logged_in?" do
    it "returns false" do
      expect(described_class.new.logged_in?).to eq(false)
    end
  end

  describe "#developer_listings" do
    it "returns a list of hireable developers" do
      developer = Developer.create(hireable: true)
      DeveloperSkill.create(developer: developer, skill: Skill.create(name: "test"))
      Developer.create(hireable: false)

      Developer.create(hireable: false)
      listing = described_class.new.developer_listings
      expect(listing).to be_a(ActiveRecord::Relation)
      expect(listing.count).to eq(1)
      expect(listing.first).to be_a(Developer)
    end
  end
end
