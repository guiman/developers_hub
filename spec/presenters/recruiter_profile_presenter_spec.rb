require "rails_helper"

describe RecruiterProfilePresenter do
  context "viewer is null user" do
    it "shows the real name" do
      recruiter = DevRecruiter.create(uid: "123")
      null_user = NullUser.new
      presenter = described_class.new(subject: recruiter, viewer: null_user)
      expect(recruiter).to receive(:name)
      presenter.name
    end

    it "shows the email" do
      recruiter = DevRecruiter.create(uid: "123")
      null_user = NullUser.new
      presenter = described_class.new(subject: recruiter, viewer: null_user)
      expect(recruiter).to receive(:email)
      presenter.email
    end

    it "shows the location" do
      recruiter = DevRecruiter.create(uid: "123")
      null_user = NullUser.new
      presenter = described_class.new(subject: recruiter, viewer: null_user)
      expect(recruiter).to receive(:location)
      presenter.location
    end

    it "shows the avatar url" do
      recruiter = DevRecruiter.create(uid: "123")
      null_user = NullUser.new
      presenter = described_class.new(subject: recruiter, viewer: null_user)
      expect(recruiter).to receive(:avatar_url)
      presenter.avatar
    end

    it "doesnt show instructions" do
      recruiter = DevRecruiter.create(uid: "123")
      null_user = NullUser.new
      presenter = described_class.new(subject: recruiter, viewer: null_user)
      expect(presenter.can_see_instructions?).to eq(false)
    end
  end

  context "viewer is developer" do
    it "shows the real name" do
      recruiter = DevRecruiter.create(uid: "123")
      developer_user = DeveloperUser.new(Developer.new)
      presenter = described_class.new(subject: recruiter, viewer: developer_user)
      expect(recruiter).to receive(:name)
      presenter.name
    end

    it "shows the email" do
      recruiter = DevRecruiter.create(uid: "123")
      developer_user = DeveloperUser.new(Developer.new)
      presenter = described_class.new(subject: recruiter, viewer: developer_user)
      expect(recruiter).to receive(:email)
      presenter.email
    end

    it "shows the location" do
      recruiter = DevRecruiter.create(uid: "123")
      developer_user = DeveloperUser.new(Developer.new)
      presenter = described_class.new(subject: recruiter, viewer: developer_user)
      expect(recruiter).to receive(:location)
      presenter.location
    end

    it "shows the avatar url" do
      recruiter = DevRecruiter.create(uid: "123")
      developer_user = DeveloperUser.new(Developer.new)
      presenter = described_class.new(subject: recruiter, viewer: developer_user)
      expect(recruiter).to receive(:avatar_url)
      presenter.avatar
    end

    it "doesnt show instructions" do
      recruiter = DevRecruiter.create(uid: "123")
      developer_user = DeveloperUser.new(Developer.new)
      presenter = described_class.new(subject: recruiter, viewer: developer_user)
      expect(presenter.can_see_instructions?).to eq(false)
    end
  end

  context "viewer is same recruiter" do
    it "shows the real name" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:name)
      presenter.name
    end

    it "shows the email" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:email)
      presenter.email
    end

    it "shows the location" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:location)
      presenter.location
    end

    it "shows the avatar url" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:avatar_url)
      presenter.avatar
    end

    it "shows instructions" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_user = RecruiterUser.new(recruiter)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(presenter.can_see_instructions?).to eq(true)
    end
  end

  context "viewer is another recruiter" do
    it "shows the real name" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_2 = DevRecruiter.create(uid: "1234")
      recruiter_user = RecruiterUser.new(recruiter_2)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:name)
      presenter.name
    end

    it "shows the email" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_2 = DevRecruiter.create(uid: "1234")
      recruiter_user = RecruiterUser.new(recruiter_2)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:email)
      presenter.email
    end

    it "shows the location" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_2 = DevRecruiter.create(uid: "1234")
      recruiter_user = RecruiterUser.new(recruiter_2)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:location)
      presenter.location
    end

    it "shows the avatar url" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_2 = DevRecruiter.create(uid: "1234")
      recruiter_user = RecruiterUser.new(recruiter_2)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(recruiter).to receive(:avatar_url)
      presenter.avatar
    end

    it "doesnt show instructions" do
      recruiter = DevRecruiter.create(uid: "123")
      recruiter_2 = DevRecruiter.create(uid: "1234")
      recruiter_user = RecruiterUser.new(recruiter_2)
      presenter = described_class.new(subject: recruiter, viewer: recruiter_user)
      expect(presenter.can_see_instructions?).to eq(false)
    end
  end
end
