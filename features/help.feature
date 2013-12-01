Feature: kitchen_boy help
  In order to know how kitchen boy works
  I should see the help in convenient commands
  And I should ask kitchen_boy for help in some subjects

  Scenario: Running with the --help flag
    When I run `kitchen_boy --help`
    Then the exit status should be 0

  Scenario: Running with the -h flag
    When I run `kitchen_boy --help`
    Then the exit status should be 0
    And the help message should be present

  Scenario: Running without arguments or options
    When I run `kitchen_boy`
    Then the exit status should be 0
    And the help message should be present

  Scenario: Running the help command
    When I run `kitchen_boy help`
    Then the exit status should be 0
    And the help message should be present

  Scenario: Running with the --version flag
    When I run `kitchen_boy --version`
    Then the exit status should be 0
    And the version should be present

  Scenario: Running with the -v flag
    When I run `kitchen_boy -v`
    Then the exit status should be 0
    And the version should be present
