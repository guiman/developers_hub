require 'rails_helper'

RSpec.describe Subscriber, :type => :model do
  it "has a valid email" do
    subscriber = described_class.new(email: "a@b.com")

    expect(subscriber).to be_valid
  end
end
