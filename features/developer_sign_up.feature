@omniauth @developer @webmock
Feature: Developer Sign up with Github

  Scenario: John signs in with Github for the first time
    Given John is new to the site
    And he wants to join as a developer
    When he clicks on Sign in with Github
    Then John should have a user created
    And he is authenticated in the site

  Scenario: John login with Github again
    Given John already has an account as a developer
    When he clicks on Sign in with Github
    Then he is authenticated in the site
