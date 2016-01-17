@webmock
Feature: Add github Developer manually
  Scenario: Frank viewer wants to watch Github user guiman
    Given Frank is a visitor
    When he reaches the main page
    Then he should not see Add Github user feature

  @omniauth @developer
  Scenario: John is a developer and wants to watch Github user guiman
    Given John already has an account as a developer
    When he clicks on Sign in with Github
    And he reaches the main page
    Then he should not see Add Github user feature

  @omniauth @recruiter
  Scenario: Alvaro recruiter wants to watch Github user guiman
    Given Alvaro is a recruiter
    When he clicks on Sign in with Linkedin
    And he reaches the main page
    Then he should not see Add Github user feature

  @omniauth @recruiter
  Scenario: Alvaro beta recruiter wants to watch Github user guiman
    Given Alvaro is a beta recruiter
    When he clicks on Sign in with Linkedin
    Then he adds guiman Github user
    And now Alvaro can see guiman profile
