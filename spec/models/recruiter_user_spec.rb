require 'rails_helper'

describe RecruiterUser do
  describe "#can_see_developer?" do
    it "it can't see any developer" do
      developer = Developer.create
      recruiter = DevRecruiter.create(uid: "123")
      current_user = described_class.new(recruiter)
      expect(current_user.can_see_developer?(developer)).to eq(false)
    end
  end

  describe "#logged_in?" do
    it "returns true" do
      expect(described_class.new(nil).logged_in?).to eq(true)
    end
  end

  describe "#developer_listings" do
    it "returns a list of hireable developers" do
      developer = Developer.create(hireable: true)
      DeveloperSkill.create(developer: developer, skill: Skill.create(name: "test"))
      Developer.create(hireable: false)
      recruiter = DevRecruiter.create(uid: '123')
      listing = described_class.new(recruiter.id).developer_listings
      expect(listing).to be_a(ActiveRecord::Relation)
      expect(listing.count).to eq(1)
      expect(listing.first).to be_a(Developer)
    end
  end
end
