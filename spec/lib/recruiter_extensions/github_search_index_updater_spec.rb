require 'rails_helper'

describe RecruiterExtensions::GithubSearchIndexUpdater do
  it "updates users that already exist" do
    expect(GeolocationAdapter).to receive(:coordinates_based_on_address).
      with("Southampton").and_return("1234,1234")

    DeveloperSkill.create(
      developer: Developer.create(login: "test", hireable: false),
      skill: Skill.create(name: "Ruby"),
      strength: 3
    )

    candidate = double(login: "test",
      name: "name",
      hireable: true,
      location: "Southampton",
      email: "my@email.com",
      avatar_url: "/my/avatar/url",
      languages: {
        :Ruby => [
          { name: "repo_a", popularity: 2, main_language: :Ruby},
          { name: "repo_b", popularity: 10, main_language: :Ruby},
          { name: "repo_b", popularity: 1, main_language: :Ruby}
        ]
      })

    described_class.new.perform_one(candidate)

    developer = Developer.first

    expect(Developer.count).to eq(1)
    expect(developer.hireable).to be_truthy
    expect(developer.developer_skills.first.strength).to eq(3)
    expect(developer.developer_skills.first.code_example).to eq("repo_b")
  end

  it "adds users to the index" do
    expect(GeolocationAdapter).to receive(:coordinates_based_on_address).
      with("Southampton").and_return("1234,1234")

    candidate = double(login: "test",
      name: "name",
      hireable: false,
      location: "Southampton",
      email: "my@email.com",
      avatar_url: "/my/avatar/url",
      languages: {
        :Java => [
          { name: "repo_a", popularity: 3, main_language: :Java },
        ]
      })

    described_class.new.perform_one(candidate)

    expect(Developer.count).to eq(1)
    expect(Skill.count).to eq(1)
    expect(Developer.first.developer_skills.first.strength).to eq(1)
  end
end
