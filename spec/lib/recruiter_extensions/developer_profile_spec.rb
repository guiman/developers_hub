require 'rails_helper'

describe RecruiterExtensions::DeveloperProfile do
  describe ".create" do
    it "creates a Developer from a github login" do
      login = "guiman"
      expect(RecruiterExtensions::UpdateDeveloperFromGithub).to receive(:perform).
        with(login, anything)
      expect do
        described_class.create(github_login: login)
      end.to change { Developer.count }.by(1)
    end

    it "returns nil if github login is not present" do
      expect do
        described_class.create(github_login: nil)
      end.to change { Developer.count }.by(0)
    end

    context "developer already exists" do
      it "returns the existing developer" do
        login = "guiman"
        existing_developer = Developer.create(login: login)
        expect do
          described_class.create(github_login: login)
        end.to change { Developer.count }.by(0)

        expect(described_class.create(github_login: login)).to eq(existing_developer)
      end
    end
  end
end
