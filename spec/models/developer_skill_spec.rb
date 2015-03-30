require 'rails_helper'

describe DeveloperSkill do
  it "should not be valid if developer is not set" do
    developer = Developer.create(uid: "1", token: "token123", login: "foobar")
    dev_skill = described_class.new(developer: developer)
    expect(dev_skill.valid?).to eq(false)
  end

  it "should not be valid if skill is not set" do
    skill = Skill.create(name: "Ruby")
    dev_skill = described_class.new(skill: skill)
    expect(dev_skill.valid?).to eq(false)
  end

  it "should be valid if skill and developer are set" do
    developer = Developer.create(uid: "1", token: "token123", login: "foobar")
    skill = Skill.create(name: "Ruby")
    dev_skill = described_class.new(developer: developer, skill: skill)

    expect(dev_skill.valid?).to eq(true)
  end
end
