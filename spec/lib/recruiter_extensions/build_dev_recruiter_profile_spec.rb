require 'rails_helper'

describe RecruiterExtensions::BuildDevRecruiterProfile do
  it "returns the existing recruiter" do
    DevRecruiter.create(uid: "123", name: "Old Test User Name")

    auth = double("auth",
                  info: double("info", first_name: "Test", last_name: "User", location: "Location", email: "email@example.com"),
                  uid: "123",
                  credentials: double("credentials", token: "1234"))

    described_class.new(auth).perform

    expect(DevRecruiter.count).to eq(1)
    expect(DevRecruiter.first.name).to eq("Old Test User Name")
  end

  it "can create a recruiter profile from a new Linkedin user" do
    auth = double("auth",
      info: double("info",
                   first_name: "Test",
                   last_name: "User",
                   location: "Location",
                   image: "/url/image.png",
                   email: "email@example.com"),
      uid: "123",
      credentials: double("credentials", token: "1234"))

    described_class.new(auth).perform

    expect(DevRecruiter.count).to eq(1)
    expect(DevRecruiter.first.uid).to eq("123")
    expect(DevRecruiter.first.token).to eq("1234")
    expect(DevRecruiter.first.name).to eq("Test User")
    expect(DevRecruiter.first.location).to eq("Location")
  end
end
