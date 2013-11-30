Feature: kitchen_boy help
  In order to know how kitchen boy works
  I should see the help in convenient commands
  And I should ask kitchen_boy for help in some subjects

  Scenario: Running help from command line
    When I get help for "kitchen_boy"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--help|-h|

  Scenario: Running without options should show help
    When I run `kitchen_boy`
    Then the exit status should be 0
    And the banner should be present
