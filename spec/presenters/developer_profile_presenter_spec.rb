require 'rails_helper'

describe DeveloperProfilePresenter do
  context "user is the same developer" do
    it "shows gravatar urls" do
      dev = Developer.create
      presenter = described_class.new(subject: dev, viewer: dev)
      expect(dev).to receive(:gravatar_url)
      expect(dev).not_to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows real name" do
      dev = Developer.create
      presenter = described_class.new(subject: dev, viewer: dev)
      expect(dev).to receive(:name)
      presenter.name
    end
  end

  context "user is another developer" do
    it "shows blurred gravatar urls" do
      dev = Developer.create(login: "test")
      dev_2 = Developer.create(login: "test_2")
      presenter = described_class.new(subject: dev, viewer: dev_2)
      expect(dev).to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows obfuscated name" do
      dev = Developer.create(login: "test")
      dev_2 = Developer.create(login: "test_2")
      presenter = described_class.new(subject: dev, viewer: dev_2)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "user null developer" do
    it "shows blurred gravatar urls" do
      dev = Developer.create(login: "test")
      presenter = described_class.new(subject: dev, viewer: NullDeveloper.new)
      expect(dev).to receive(:blurred_gravatar_url)
      presenter.avatar
    end

    it "shows obfuscated name" do
      dev = Developer.create(login: "test")
      presenter = described_class.new(subject: dev, viewer: NullDeveloper.new)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end
end
