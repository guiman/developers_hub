require 'rails_helper'

describe DeveloperListingPresenter do
  describe "#cast" do
    it "creates a list of Developer Listing Presenters" do
      candidates = Developer.all
      viewer = NullUser.new
      Developer.create(login: "test")
      developer = Developer.create(login: "test2")
      developer.skills << Skill.create(name: "ruby")
      presenter_listings = DeveloperListingPresenter.cast(candidates, viewer: viewer)
      expect(presenter_listings).to be_an(Array)
      expect(presenter_listings.count).to eq(1)
      expect(presenter_listings.first).to be_a(DeveloperListingPresenter)
    end
  end

  context "user is the same developer" do
    it "shows obfuscated_name" do
      dev = Developer.create
      dev_user = DeveloperUser.new(Developer.create)
      presenter = described_class.new(subject: dev, viewer: dev_user)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "user is another developer" do
    it "shows obfuscated_name" do
      dev = Developer.create(login: "123")
      dev_user = DeveloperUser.new(Developer.create(login: "1234"))
      presenter = described_class.new(subject: dev, viewer: dev_user)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "user is null" do
    it "shows obfuscated_name" do
      dev = Developer.create
      presenter = described_class.new(subject: dev, viewer: NullUser.new)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "user recruiter" do
    it "shows obfuscated_name" do
      dev = Developer.create
      recruiter_user = RecruiterUser.new(DevRecruiter.create(uid: "123", beta_user: false))
      presenter = described_class.new(subject: dev, viewer: recruiter_user)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end

    context "with beta_user access" do
      it "shows real name" do
        dev = Developer.create
        recruiter_user = RecruiterUser.new(DevRecruiter.create(uid: "123", beta_user: true))
        presenter = described_class.new(subject: dev, viewer: recruiter_user)
        expect(dev).to receive(:name)
        presenter.name
      end
    end
  end
end
