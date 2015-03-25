 require "spec_helper"

 describe RecruiterExtensions::FilterIndexedUsers do
   it "can filter by language and geolocation" do
     user = RecruiterExtensions::IndexedUser.create(hireable: true, geolocation: "1,2")
     RecruiterExtensions::IndexedUser.create(hireable: true, location: "Portsmouth, UK", languages: { Ruby: 3 })
     RecruiterExtensions::IndexedUser.create(hireable: true, location: "Portsmouth, UK", languages: { JavaScript: 2 })

     filter = described_class.new(geolocation: "1,2")

     expect(filter.all.count).to eq(1)
     expect(filter.all.first).to eq(user)
   end

   it "can filter by language and location" do
     user = RecruiterExtensions::IndexedUser.create(hireable: true, location: "Southampton, UK", languages: { Ruby: 3 })
     RecruiterExtensions::IndexedUser.create(hireable: true, location: "Portsmouth, UK", languages: { Ruby: 3 })
     RecruiterExtensions::IndexedUser.create(hireable: false, location: "Portsmouth, UK", languages: { Ruby: 3 })
     RecruiterExtensions::IndexedUser.create(hireable: true, location: "Portsmouth, UK", languages: { JavaScript: 2 })

     filter = described_class.new(language: "ruby", location: "portsmouth")
     expect(filter.all.count).to eq(1)
     expect(filter.all.first).to eq(user)
   end

   it "can filter by language" do
     user = RecruiterExtensions::IndexedUser.create(hireable: true, location: "Southampton, UK", languages: { Ruby: 3 })
     RecruiterExtensions::IndexedUser.create(hireable: true, location: "Portsmouth, UK", languages: { JavaScript: 2 })

     filter = described_class.new(language: "ruby")
     expect(filter.all.count).to eq(1)
     expect(filter.all.first).to eq(user)
   end

   it "can filter by location" do
     user = RecruiterExtensions::IndexedUser.create(hireable: true, location: "Southampton, UK")
     RecruiterExtensions::IndexedUser.create(hireable: true, location: "Portsmouth, UK")

     filter = described_class.new(location: "southampton")
     expect(filter.all.count).to eq(1)
     expect(filter.all.first).to eq(user)
   end

   it "returns all hireable users when no location is provided" do
     RecruiterExtensions::IndexedUser.create(hireable: true, location: "Southampton, UK")

     filter = described_class.new
     expect(filter.all).not_to be_empty
   end
 end
