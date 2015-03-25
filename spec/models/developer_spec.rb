require 'rails_helper'

RSpec.describe Developer, :type => :model do
  it "can be stored in a database" do
    developer = described_class.new
    developer.github_login = "test"
    expect(developer.save).to eq(true)
    expect(described_class.find_by_github_login(developer.github_login)).to eq(developer)
  end

  it "can handle languages structure" do
    developer = described_class.new
    languages = { ruby: 1, javascript: 2 }
    developer.languages = languages
    developer.save

    expect(developer.languages).to eq(languages)
  end

  it "can be compared to another object" do
    developer_a = described_class.new
    developer_b = described_class.new

    expect(developer_a).to eq(developer_b)
    developer_a.github_login = "another_github_login"
    expect(developer_a).not_to eq(developer_b)
  end
end
