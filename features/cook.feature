Feature: kitchen_boy cook
  In order to apply kitchen_boy recipes
  The user can call the binary with the recipe name
  The cook action will also be aliased with install

  Scenario: Running a recipe that uses thor actions
    Given a created kitchen_boy home directory
    And a file named ".kitchen_boy/fake_repo/thor_test.rb" with:
      """
      create_file("genesis", "content")
      """
    When I run `kitchen_boy cook thor_test`
    Then the exit status should be 0
    And the file "genesis" should contain:
      """
      content
      """

  Scenario: Running a recipe that uses rails actions
