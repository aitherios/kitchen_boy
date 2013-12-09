Feature: kitchen_boy cook
  In order to apply kitchen_boy recipes
  The user can call the binary with the recipe name
  The cook action will also be aliased with install

  Scenario: Running a recipe in ruby extension
    Given a created kitchen_boy home directory
    And a file named ".kitchen_boy/fake_repo/dir/write_file.rb" with:
      """
      File.open('genesis', 'w') { |f| f.write('content') }
      """
    When I run kitchen_boy cook "write_file"
    Then the exit status should be 0
    # And the output should contain:
    #   """
    #   Cooking fake_repo/dir write_file.rb
    #   """
    And the file "genesis" should contain:
      """
      content
      """

  @wip
  Scenario: Running a recipe that uses thor actions

  Scenario: Running a recipe that uses rails actions

  Scenario: Passing arguments to the ruby recipe
