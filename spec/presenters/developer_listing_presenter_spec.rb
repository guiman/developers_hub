require 'rails_helper'

describe DeveloperListingPresenter do
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
      recruiter_user = RecruiterUser.new(DevRecruiter.create(uid: "123"))
      presenter = described_class.new(subject: dev, viewer: recruiter_user)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end
end
