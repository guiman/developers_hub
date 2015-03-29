require 'rails_helper'

describe DeveloperListingPresenter do
  context "user is the same developer" do
    it "shows obfuscated_name" do
      dev = Developer.create
      presenter = described_class.new(subject: dev, viewer: dev)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "user is another developer" do
    it "shows obfuscated_name" do
      dev = Developer.create
      dev_2 = Developer.create(login: "123")
      presenter = described_class.new(subject: dev, viewer: dev_2)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end

  context "user null developer" do
    it "shows obfuscated_name" do
      dev = Developer.create
      presenter = described_class.new(subject: dev, viewer: NullUser.new)
      expect(dev).to receive(:obfuscated_name)
      presenter.name
    end
  end
end
