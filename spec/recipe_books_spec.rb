require 'spec_helper'

describe KitchenBoy::RecipeBooks do
  before { @config = KitchenBoy::Config.new $home_dir }

  describe ".load_recipe_books" do

    context "when there is git repositories" do
      before do
        File.open(@config.recipe_books_file_path, 'w') do |f|
          f.write <<-STRING
            git    'https://aitherios@bitbucket.org/aitherios/kitchen_boy_recipe_book.git'
            github 'aitherios/kitchen_boy_recipe_book'
          STRING
        end

        KitchenBoy::RecipeBooks.new(@config).load_recipe_books
      end

      it { expect(@config.recipe_books).to include(
          'https://aitherios@bitbucket.org/aitherios/kitchen_boy_recipe_book.git') }

      it { expect(@config.recipe_books).to include(
          'https://github.com/aitherios/kitchen_boy_recipe_book.git') }

      context "that are malformed"
    end

    context "when there is directory" do
      before do
        File.open(@config.recipe_books_file_path, 'w') do |f|
          f.write <<-STRING
            directory '/users'
          STRING
        end

        KitchenBoy::RecipeBooks.new(@config).load_recipe_books
      end

      context "that can't be read"
    end

  end

end
