Feature: create subcommand

  In order to make blogs for hackers
  As a hacker using the octopress executable
  I want to create a blog using a theme

  Scenario: No flags, switches or arguments
    When I successfully run `octopress create`
    Then a theme-classic project structure should exist

  Scenario: Path argument provided
    When I successfully run `octopress create pathto/myblog`
    Then a directory named "pathto/myblog" should exist
    When I cd to "pathto/myblog"
    Then a theme-classic project structure should exist

  Scenario: directory exists
