
Feature: Watir Demo

Scenario: Watir Demo Text Field
    Given I open google chrome browser on remote host
    Then I go to address http://bit.ly/watir-example
    Then I enter text "Mary" into the "name" field
    Then I close the browser
