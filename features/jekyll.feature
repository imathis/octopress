Feature: Jekyll integration
  Scenario: Install octopress
    When I install octopress
    Then I should have created an octopress skeleton

  Scenario: Create a post
    When I install octopress
    And I create a new post
    Then I should see that post

  Scenario: Create a page
    When I install octopress
    And I create a new page
    Then I should see that page
