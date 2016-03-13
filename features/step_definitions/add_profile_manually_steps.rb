Given(/Frank is a visitor/) do
end

When(/he reaches the main page/) do
 visit "/"
end

Then(/he should not see Add Github user feature/) do
  expect(page.body).not_to have_css("ul li#add_github_developer")
end

Given(/John already has an account as a developer/) do
  Developer.create(uid: 9999, login: 'test_user',
    needs_update_contributions: false)

  expect(DeveloperUpdaterWorker).to receive(:perform_async).
    with("test_user", { parse_contributions: false }).once
end
