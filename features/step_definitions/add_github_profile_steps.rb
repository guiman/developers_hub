Then(/he adds (.+) Github user/) do |github_login|
  expect(RecruiterExtensions::UpdateDeveloperFromGithub).to receive(:perform).
    with(github_login, {:parse_contributions=>false})
  click_link 'Add Github Developer'
  fill_in 'github_login', with: github_login
  click_button 'Create'
end

And(/now Alvaro can see (.+) profile/) do |github_login|
  expect(Developer.find_by_login(github_login)).not_to be_nil
  expect(page.body).to have_css("div#chart")
end
