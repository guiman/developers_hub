@hireable_ruby_dev @webmock
Feature: Add Developer to Watchlist
  Scenario: Frank viewer wants to watch developer
    Given Frank is a visitor
    And he reaches Pete developer's page
    Then he should not see Watch user feature

  @omniauth @developer
  Scenario: John is a developer and wants to watch Github user guiman
    Given John already has an account as a developer
    When he clicks on Sign in with Github
    And he reaches Pete developer's page
    Then he should not see Watch user feature

  @omniauth @recruiter
  Scenario: Alvaro recruiter wants to watch Github user guiman
    Given Alvaro is a recruiter
    When he clicks on Sign in with Linkedin
    And he reaches Pete developer's page
    Then he should not see Watch user feature

  @omniauth @recruiter
  Scenario: Alvaro beta recruiter wants to watch Github user guiman
    Given Alvaro is a beta recruiter
    When he clicks on Sign in with Linkedin
    And he reaches Pete developer's page
    Then he adds Pete to his watchlist

  @omniauth @recruiter
  Scenario: Alvaro beta recruiter wants to stop watching Github user guiman
    Given Alvaro is a beta recruiter
    And he is already watching Pete
    When he clicks on Sign in with Linkedin
    And he reaches Pete developer's page
    Then he removes Pete from his watchlist
