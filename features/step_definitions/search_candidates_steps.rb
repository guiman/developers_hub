Given(/Alvaro is a recruiter/) do
  DevRecruiter.create(
    name: 'Example User',
    email: 'test@example.com',
    uid: 9999,
    token: '123',
    avatar_url: 'profile_picture',
    location: 'Somewhere in a Galaxy far away')
end

Given(/Alvaro is a beta recruiter/) do
  DevRecruiter.create(
    name: 'Example User',
    email: 'test@example.com',
    uid: 9999,
    token: '123',
    avatar_url: 'profile_picture',
    beta_user: true,
    location: 'Somewhere in a Galaxy far away')
end

Then(/he visits the search page/) do
  visit "/search"
end

And(/fills the form for (\w+) skill/) do |skill_name|
  fill_in 'languages', with: skill_name
  click_button 'Search'
end

Then(/he can see a list of (\d+) developer with (\w+) as a skill/) do |result_count, skill_name|
  expect(page.body).to have_css("div.developers-table-row", :count => result_count)
end
