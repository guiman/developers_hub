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

  describe "#contact_developer" do
    context "user is a beta recruiter" do
      it "creates an offer" do
        developer = Developer.create(login: "dev")
        recruiter = DevRecruiter.create(uid: "rec", beta_user: true)
        recruiter_user = RecruiterUser.new(recruiter)
        current_user = described_class.new(recruiter_user)
        developer_profile_presenter = DeveloperProfilePresenter.new(
          subject: developer, viewer: recruiter_user)

        expect_any_instance_of(OfferMailer).to receive(:new_offer)

        expect do
          current_user.contact_developer(developer_profile_presenter, message: "hello")
        end.to change { Offer.count }.by(1)
      end
    end

    context "user is a normal recruiter" do
      it "creates an offer" do
        developer = Developer.create(login: "dev")
        recruiter = DevRecruiter.create(uid: "rec", beta_user: false)
        recruiter_user = RecruiterUser.new(recruiter)
        current_user = described_class.new(recruiter_user)
        developer_profile_presenter = DeveloperProfilePresenter.new(
          subject: developer, viewer: recruiter_user)

        expect_any_instance_of(OfferMailer).to_not receive(:new_offer)

        current_user.contact_developer(developer_profile_presenter, message: "hello")

        expect(Offer.count).to eq(0)
      end
    end

    context "user is a null user" do
      it "creates an offer" do
        developer = Developer.create(login: "dev")
        null_user = NullUser.new
        current_user = described_class.new(null_user)
        developer_profile_presenter = DeveloperProfilePresenter.new(
          subject: developer, viewer: null_user)

        expect_any_instance_of(OfferMailer).to_not receive(:new_offer)

        current_user.contact_developer(developer_profile_presenter, message: "hello")

        expect(Offer.count).to eq(0)
      end
    end

    context "user is a developer user" do
      it "creates an offer" do
        developer = Developer.create(login: "dev")
        developer_2 = Developer.create(login: "dev_2")
        developer_user = DeveloperUser.new(developer_2)
        current_user = described_class.new(developer_user)
        developer_profile_presenter = DeveloperProfilePresenter.new(
          subject: developer, viewer: developer_user)

        expect_any_instance_of(OfferMailer).to_not receive(:new_offer)

        current_user.contact_developer(developer_profile_presenter, message: "hello")

        expect(Offer.count).to eq(0)
      end
    end
  end
end
