require 'rails_helper'

describe RecruiterUser do
  describe "#can_see_developer?" do
    it "it can't see any developer" do
      developer = Developer.create
      recruiter = DevRecruiter.create(uid: "123", beta_user: false)
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
    context "is beta user" do
      it "returns a list of all developers" do
        developer = Developer.create(hireable: false)
        DeveloperSkill.create(developer: developer, skill: Skill.create(name: "test"))
        recruiter = DevRecruiter.create(uid: '123', beta_user: true)
        listing = described_class.new(recruiter).developer_listings
        expect(listing).to be_a(ActiveRecord::Relation)
        expect(listing.count).to eq(1)
        expect(listing.first).to be_a(Developer)
      end
    end

    it "returns a list of hireable developers" do
      skill = Skill.create(name: "test")
      developer = Developer.create(hireable: true)
      DeveloperSkill.create(developer: developer, skill: skill)
      Developer.create(hireable: false)
      developer_2 = Developer.create(hireable: false)
      DeveloperSkill.create(developer: developer_2, skill: skill)

      recruiter = DevRecruiter.create(uid: '123', beta_user: false)
      listing = described_class.new(recruiter).developer_listings
      expect(listing).to be_a(ActiveRecord::Relation)
      expect(listing.count).to eq(1)
      expect(listing.first).to be_a(Developer)
    end
  end
end
