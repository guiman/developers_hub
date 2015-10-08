require "rails_helper"

describe CurrentUser do
  describe ".from_session" do
    it "returns a null user when session in nil" do
      current_user = described_class.from_session(developer_id: nil, recruiter_id: nil)
      expect(current_user.is_a_developer?).to eq(false)
      expect(current_user.is_a_recruiter?).to eq(false)
    end

    it "returns a developer user when developer_id is present" do
      developer = Developer.create
      current_user = described_class.from_session(developer_id: developer.id, recruiter_id: nil)
      expect(current_user.is_a_developer?).to eq(true)
      expect(current_user.is_a_recruiter?).to eq(false)
      expect(current_user.user.developer).to be_a(Developer)
    end

    it "returns a recruiter user when recruiter_id is present" do
      recruiter = DevRecruiter.create(uid: "123")
      current_user = described_class.from_session(developer_id: nil, recruiter_id: recruiter.id)
      expect(current_user.is_a_developer?).to eq(false)
      expect(current_user.is_a_recruiter?).to eq(true)
      expect(current_user.user.recruiter).to be_a(DevRecruiter)
    end
  end

  describe "sending methods it doesn't implement" do
    it "redirects the message to the internal user" do
      user = double("user", is_it_me_you_are_looking_for?: true)
      current_user = described_class.new(user)
      expect(user).to receive(:is_it_me_you_are_looking_for?).and_return(true)

      current_user.is_it_me_you_are_looking_for?
    end
  end
end
