require "rails_helper"

describe RecruiterExtensions::FilterDevelopers do
  it "can filter by language and geolocation" do
    ruby = Skill.create(name: "Ruby")
    js = Skill.create(name: "JavaScript")

    user = Developer.create(hireable: true, geolocation: "1,2")
    DeveloperSkill.create(developer: user, skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(hireable: true, location: "Portsmouth, UK"),
                          skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(hireable: true, location: "Portsmouth, UK"),
                          skill: js, strength: 2)

    filter = described_class.new(geolocation: "1,2")

    expect(filter.all.count).to eq(1)
    expect(filter.all.first).to eq(user)
  end

  it "can filter by language and location" do
    ruby = Skill.create(name: "Ruby")
    js = Skill.create(name: "JavaScript")

    user = Developer.create(hireable: true, location: "Southampton, UK")

    DeveloperSkill.create(developer: user,
                          skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(hireable: true, location: "Portsmouth, UK"),
                          skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(hireable: false, location: "Portsmouth, UK"),
                          skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(hireable: true, location: "Portsmouth, UK"),
                          skill: js, strength: 2)

    filter = described_class.new(language: "ruby", location: "portsmouth")
    expect(filter.all.count).to eq(1)
    expect(filter.all.first).to eq(user)
  end

  it "can filter by language" do
    ruby = Skill.create(name: "Ruby")
    js = Skill.create(name: "JavaScript")

    user = Developer.create(hireable: true, location: "Southampton, UK")

    DeveloperSkill.create(developer: user, skill: ruby, strength: 3)
    DeveloperSkill.create(developer: Developer.create(hireable: true, location: "Portsmouth, UK"),
                          skill: js, strength: 2)

    filter = described_class.new(language: "ruby")
    expect(filter.all.count).to eq(1)
    expect(filter.all.first).to eq(user)
  end

  it "can filter by location" do
    user = Developer.create(hireable: true, location: "Southampton, UK")
    ruby = Skill.create(name: "Ruby")
    DeveloperSkill.create(developer: user, skill: ruby, strength: 3)
    Developer.create(hireable: true, location: "Portsmouth, UK")

    filter = described_class.new(location: "southampton")
    expect(filter.all.count).to eq(1)
    expect(filter.all.first).to eq(user)
  end

  it "returns all hireable users when no location is provided" do
    user = Developer.create(hireable: true, location: "Southampton, UK")
    ruby = Skill.create(name: "Ruby")
    DeveloperSkill.create(developer: user, skill: ruby, strength: 3)

    filter = described_class.new
    expect(filter.all).not_to be_empty
  end
end
