require 'rails_helper'

describe DeveloperHelper do
  let(:subject_class) do
    Class.new do
      extend DeveloperHelper
    end
  end

  describe ".candidate_top_skills" do
    it "returns a list of the top 2 skill a developer has" do
      ruby = Skill.create(name: "Ruby")
      js = Skill.create(name: "JavaScript")
      css = Skill.create(name: "CSS")

      dev_1 = Developer.create(login: "test 1")
      DeveloperSkill.create(developer: dev_1, skill: ruby, strength: 2)
      DeveloperSkill.create(developer: dev_1, skill: js, strength: 3)
      DeveloperSkill.create(developer: dev_1, skill: css, strength: 1)

      expect(subject_class.candidate_top_skills(candidate: dev_1, top: 2)).to eq("JavaScript: 3, Ruby: 2")
    end
  end
end
