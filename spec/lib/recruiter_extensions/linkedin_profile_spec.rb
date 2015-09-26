require "spec_helper"

describe RecruiterExtensions::LinkedinProfile do
  it "returns a link to the linkedin profile from a github username" do
    linkedin_profile = described_class.new("guiman")
    expect(linkedin_profile.link).not_to be_nil
  end
end
