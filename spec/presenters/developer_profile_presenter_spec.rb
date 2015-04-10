require 'rails_helper'

describe DeveloperProfilePresenter do
  context "viewer is the same developer" do
    it "shows gravatar urls" do
      dev = Developer.create
      developer_user = DeveloperUser.new(dev)
      presenter = described_class.new(subject: dev, viewer: developer_user)
      expect(dev).to receive(:gravatar_url)
      expect(dev).not_to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows real name" do
      dev = Developer.create
      developer_user = DeveloperUser.new(dev)
      presenter = described_class.new(subject: dev, viewer: developer_user)
      expect(dev).to receive(:name)
      presenter.name
    end
  end

  context "viewer is another developer" do
    it "shows blurred gravatar urls" do
      dev = Developer.create(login: "test")
      dev_2 = Developer.create(login: "test_2")
      developer_user = DeveloperUser.new(dev_2)
      presenter = described_class.new(subject: dev, viewer: developer_user)
      expect(dev).to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows obfuscated name" do
      dev = Developer.create(login: "test")
      dev_2 = Developer.create(login: "test_2")
      developer_user = DeveloperUser.new(dev_2)
      presenter = described_class.new(subject: dev, viewer: developer_user)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "viewer is null developer" do
    it "shows blurred gravatar urls" do
      dev = Developer.create(login: "test")
      presenter = described_class.new(subject: dev, viewer: NullUser.new)
      expect(dev).to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows obfuscated name" do
      dev = Developer.create(login: "test")
      presenter = described_class.new(subject: dev, viewer: NullUser.new)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "viewer is a recruiter" do
    it "shows blurred gravatar urls" do
      dev = Developer.create(login: "test")
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: dev, viewer: recruiter_user)
      expect(dev).to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows obfuscated name" do
      dev = Developer.create(login: "test")
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: dev, viewer: recruiter_user)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "viewer is a beta recruiter" do
    it "shows gravatar urls" do
      dev = Developer.create(login: "test")
      recruiter = DevRecruiter.create(uid: "123", beta_user: true)
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: dev, viewer: recruiter_user)
      expect(dev).to receive(:gravatar_url)
      expect(dev).not_to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows real name" do
      dev = Developer.create(login: "test")
      recruiter = DevRecruiter.create(uid: "123", beta_user: true)
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: dev, viewer: recruiter_user)
      expect(dev).to receive(:name)
      presenter.name
    end
  end
end
