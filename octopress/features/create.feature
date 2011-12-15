Feature: Create a new Octopress Blog

  Scenario: create with no flags, switches or arguments
    When I successfully run `octopress create`
    Then the stdout should contain "Hello!"
