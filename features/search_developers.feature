Feature: Search for developers

  @omniauth_test @hireable_js_dev @non_hireable_js_dev @hireable_ruby_dev
  Scenario: Recruiter searches for Javascript developers
    Given Alvaro is a recruiter
    And he clicks on Sign in with Linkedin
    When he visits the search page
    And fills the form for Javascript skill
    Then he can see a list of 1 developer with Javascript as a skill

  @omniauth_test @hireable_js_dev @non_hireable_js_dev @hireable_ruby_dev
  Scenario: Beta Recruiter searches for Javascript developers
    Given Alvaro is a beta recruiter
    And he clicks on Sign in with Linkedin
    When he visits the search page
    And fills the form for Javascript skill
    Then he can see a list of 2 developer with Javascript as a skill
