When(/he reaches Pete developer's page/) do
  developer = Developer.find_by_login("hireable dev")
  visit developer_profile_path(developer.secure_reference)
end

Then(/he should not see Watch user feature/) do
  expect(page.body).not_to have_content("Watch developer")
end

And(/he is already watching Pete/) do
  recruiter = DevRecruiter.find_by_uid('9999')
  developer = Developer.find_by_login("hireable dev")
  recruiter.developers << developer
end

Then(/he adds Pete to his watchlist/) do
  expect do
    click_link "Watch developer"
  end.to change { DeveloperWatcher.count }.by(1)
end

Then(/he removes Pete from his watchlist/) do
  expect do
    click_link "Stop watching developer"
  end.to change { DeveloperWatcher.count }.by(-1)
end
