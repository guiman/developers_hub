And(/he is authenticated in the site/) do
  expect(page.body).to have_css("li a", text: "Logout")
end

When(/he clicks on Sign in with Github/) do
  visit "/"
  click_link 'Developer signin Github'
end

When(/he clicks on Sign in with Linkedin/) do
  visit "/"
  click_link 'Recruiter signin Linkedin'
end
