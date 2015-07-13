require 'rails_helper'

describe RecruiterExtensions::BuildDeveloperProfile do
  describe "#perform" do
    it "can update a user profile from a new Developer" do
      Developer.create(uid: "123")

      auth = double("auth",
                    uid: "123",
                    credentials: double("credentials", token: "123"),
                    extra: double(raw_info: double(login: "guiman")))

      allow(Geokit::Geocoders::MapboxGeocoder).to receive(:geocode).and_return(double("location", ll: ""))
      allow(Octokit::Client).to receive_message_chain(:new, :user)
      expect(DeveloperUpdaterWorker).to receive(:perform_async)

      RecruiterExtensions::BuildDeveloperProfile.new(auth).perform

      expect(Developer.count).to eq(1)
    end
  end
end
