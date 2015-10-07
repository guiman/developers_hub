Given(/[Alvaro|he|John] clicks on Sign in with (Linkedin|Github)/) do |auth_method|
  visit "/"
  if auth_method == "Linkedin"
    click_link 'Recruiter signin Linkedin'
  elsif auth_method == "Github"
    click_link 'Developer signin Github'
  else
    raise "Unrecognized auth method: #{auth_method}"
  end
end

And(/he is authenticated in the site/) do
  expect(page.body).to have_css("li a", text: "Logout")
end

