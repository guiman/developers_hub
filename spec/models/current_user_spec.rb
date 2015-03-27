require "rails_helper"

describe CurrentUser do
  describe ".from_session" do
    it "returns a null user when session in nil" do
      user = described_class.from_session(developer_id: nil, recruiter_id: nil)
      expect(user).to be_a(DeveloperUser)
      expect(user.developer).to be_a(NullDeveloper)
    end

    it "returns a developer user when developer_id is present" do
      developer = Developer.create
      user = described_class.from_session(developer_id: developer.id, recruiter_id: nil)
      expect(user).to be_a(DeveloperUser)
    end

    it "returns a recruiter user when recruiter_id is present" do
      recruiter = DevRecruiter.create(uid: "123")
      user = described_class.from_session(developer_id: nil, recruiter_id: recruiter.id)
      expect(user).to be_a(RecruiterUser)
    end
  end
end
