@omniauth @recruiter
Feature: Recruiters sign in with Linkedin
  Scenario: Alvaro signs in with his Linkedin account for the first time
    Given Alvaro is new to the site
    When he clicks on Sign in with Linkedin
    Then Alvaro should have a user created
    And he is authenticated in the site

  Scenario: Alvaro signs in with his Linkedin account again
    Given Alvaro already has an account
    When he clicks on Sign in with Linkedin
    Then he is authenticated in the site
