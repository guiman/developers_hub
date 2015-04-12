require 'rails_helper'

describe Skill do
  it "should not be valid if skill has blank name" do
    skill = Skill.new(name: '')
    expect(skill.valid?).to eq(false)
  end
end
