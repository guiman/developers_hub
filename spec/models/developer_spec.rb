require 'rails_helper'

RSpec.describe Developer, :type => :model do
  it "can be stored in a database" do
    developer = described_class.new
    developer.login = "test"
    expect(developer.save).to eq(true)
    expect(described_class.find_by_login(developer.login)).to eq(developer)
  end

  it "can be compared to another object" do
    developer_a = described_class.new
    developer_b = described_class.new

    expect(developer_a).to eq(developer_b)
    developer_a.login = "another_login"
    expect(developer_a).not_to eq(developer_b)
  end
end
