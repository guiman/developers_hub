require 'spec_helper'

describe RecruiterExtensions::GithubSearchIndexUpdater do

  it "updates users that already exist" do
    Developer.create(github_login: "test", hireable: false)

    candidate = double(github_login: "test",
      name: "name",
      hireable: true,
      location: "Southampton",
      email: "my@email.com",
      languages: {})

    candidates = [ candidate ]

    described_class.new(candidates).perform

    expect(Developer.count).to eq(1)
    expect(Developer.first.hireable).to be_truthy
  end

  it "adds users to the index" do
    candidate = double(github_login: "test",
      name: "name",
      hireable: false,
      location: "Southampton",
      email: "my@email.com",
      languages: {})

    candidates = [ candidate ]

    described_class.new(candidates).perform

    expect(Developer.count).to eq(1)
  end
end
