Given(/John is new to the site/) do
  expect(Developer.count).to eq(0)
end

Then(/John should have a user created/) do
  expect(Developer.find_by_uid(9999)).not_to be_nil
  expect(Developer.count).to eq(1)
end

And(/he wants to join as a developer/) do
  expect(RecruiterExtensions::UpdateDeveloperFromGithub).to receive(:perform).
    with("test_user", {parse_contributions: false}).once
  expect(DeveloperUpdaterWorker).to receive(:perform_async).
    with("test_user", {parse_contributions: true }).once
end
