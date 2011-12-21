Feature: create subcommand

  In order to make blogs for hackers
  As a hacker using the octopress executable
  I want to generate a blog from a template

  Scenario: No flags, switches or arguments
    When I successfully run `octopress create`
    Then the octopress blog files should exist

  Scenario: Path argument provided
    When I successfully run `octopress create pathto/myblog`
    Then a directory named "pathto/myblog" should exist
    When I cd to "pathto/myblog"
    Then the octopress blog files should exist

  Scenario: directory exists
