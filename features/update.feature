Feature: kitchen_boy update
  In order to update kitchen_boy recipes
  I should call kitchen_boy update
  In can also specify new recipe books

  Scenario: Updating kitchen_boy in a new installation
    Given an inexistent kitchen_boy home directory
    When I run kitchen_boy update
    Then the exit status should be 0
    And the updated message should be present
    And kitchen_boy home directory exists
    And kitchen_boy default recipe book was downloaded
    And the file ".kitchen_boy/recipe_books" should contain:
      """
      ## Add an external recipe book from a git repository with:
      #  git 'https://github.com/aitherios/kitchen_boy_recipe_book.git'
      #
      ## Add an external recipe book from a github repository with:
      #  github 'aitherios/kitchen_boy_recipe_book'
      #
      ## Add an external recipe book from a local directory with:
      #  directory '/home/users/kitchen_boy/weird_recipe_book'
      """

  Scenario: Updating kitchen_boy using an invalid home directory
    Given an invalid kitchen_boy home directory
    When I run kitchen_boy update
    Then the exit status should not be 0
    And the updating error message should be present
