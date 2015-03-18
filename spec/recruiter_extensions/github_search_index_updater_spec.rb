require 'spec_helper'

describe RecruiterExtensions::GithubSearchIndexUpdater do

  it "updates users that already exist" do
    RecruiterExtensions::IndexedUser.create(login: "test", hireable: false)

    candidate = double(login: "test",
      name: "name",
      hireable: true,
      location: "Southampton",
      email: "my@email.com",
      languages: {})

    candidates = [ candidate ]

    described_class.new(candidates).perform

    expect(RecruiterExtensions::IndexedUser.count).to eq(1)
    expect(RecruiterExtensions::IndexedUser.first.hireable).to be_truthy
  end

  it "adds users to the index" do
    candidate = double(login: "test",
      name: "name",
      hireable: false,
      location: "Southampton",
      email: "my@email.com",
      languages: {})

    candidates = [ candidate ]

    described_class.new(candidates).perform

    expect(RecruiterExtensions::IndexedUser.count).to eq(1)
  end
end
