Given(/Alvaro is new to the site/) do
  expect(DevRecruiter.count).to eq(0)
end

Given(/Alvaro already has an account/) do
  DevRecruiter.create(
    name: 'Example User',
    email: 'test@example.com',
    uid: 9999,
    token: '123',
    avatar_url: 'profile_picture',
    location: 'Somewhere in a Galaxy far away')
end

Then(/Alvaro should have a user created/) do
  expect(DevRecruiter.find_by_uid(9999)).not_to be_nil
  expect(DevRecruiter.count).to eq(1)
end

And(/he has a user already created/) do
  expect(DevRecruiter.find_by_uid(9999)).not_to be_nil
  expect(DevRecruiter.count).to eq(1)
end
