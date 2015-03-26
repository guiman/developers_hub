require 'rails_helper'

describe DeveloperListingPresenter do
  it "shows obfuscated_name" do
    dev = Developer.create
    presenter = described_class.new(subject: dev, viewer: dev)
    expect(dev).to receive(:obfuscated_name)
    presenter.name
  end
end
