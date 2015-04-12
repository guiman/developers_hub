require 'rails_helper'

describe RecruiterExtensions::GithubSearchIndexUpdater do

  it "updates users that already exist" do
    DeveloperSkill.create(developer: Developer.create(login: "test", hireable: false),
      skill: Skill.create(name: "Ruby"), strength: 3)

    candidate = double(login: "test",
      name: "name",
      hireable: true,
      location: "Southampton",
      email: "my@email.com",
      avatar_url: "/my/avatar/url",
      languages: { :Ruby => 4 })

    candidates = [ candidate ]

    described_class.new(candidates).perform

    developer = Developer.first

    expect(Developer.count).to eq(1)
    expect(developer.hireable).to be_truthy
    expect(developer.developer_skills.first.strength).to eq(4)
  end

  it "adds users to the index" do
    candidate = double(login: "test",
      name: "name",
      hireable: false,
      location: "Southampton",
      email: "my@email.com",
      avatar_url: "/my/avatar/url",
      languages: { :Java => 1 })

    candidates = [ candidate ]

    described_class.new(candidates).perform

    expect(Developer.count).to eq(1)
    expect(Skill.count).to eq(1)
    expect(Developer.first.developer_skills.first.strength).to eq(1)
  end
end
