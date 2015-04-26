require "spec_helper"

describe RecruiterExtensions::LinkedinProfile do
  it "returns a link to the linkedin profile from a github username" do
    linkedin_profile = described_class.new("guiman")
    expect(linkedin_profile.link).not_to be_nil
  end

  it "returns a list of skills" do
    linkedin_profile = described_class.new("guiman")
    expect(linkedin_profile.skills).to include("Ruby on Rails")
  end

  it "returns the headline" do
    linkedin_profile = described_class.new("guiman")
    expect(linkedin_profile.headline).to include("Lead Developer at Alliants Limited")
  end

  it "returns the experience" do
    linkedin_profile = described_class.new("guiman")
    expect(linkedin_profile.experience).to include({
      :position=>"Lead Developer",
      :company=>"Alliants Limited",
      :period=>"August 2013 – Present (1 year 9 months)Southampton, United Kingdom",
      :current=>true})
  end

  it "returns the education" do
    linkedin_profile = described_class.new("guiman")
    expect(linkedin_profile.education).to eq({:university=>"Universidad Nacional de La Plata", :degree=>"Analista programador universitario, Informatica"})
  end
end
