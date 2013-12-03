require 'spec_helper'

describe KitchenBoy::RecipeBooks do
  before { @config = KitchenBoy::Config.new $home_dir }

  describe ".load_recipe_books" do
    let(:github_repo) { 'https://github.com/aitherios/kitchen_boy_recipe_book.git' }
    let(:github_shorthand) { 'aitherios/kitchen_boy_recipe_book' }
    let(:git_repo) { 'https://aitherios@bitbucket.org/aitherios/kitchen_boy_recipe_book.git' }
    let(:malformed_git_repo) { '://aitherios @bitbucket .org/aith' }

    context "when there is git repositories" do
      before do
        write_recipe_books_file @config, <<-STRING
          git    '#{git_repo}'
          github '#{github_shorthand}'
        STRING

        KitchenBoy::RecipeBooks.new(@config).load_recipe_books
      end

      it { expect(@config.recipe_books).to include(github_repo) }
      it { expect(@config.recipe_books).to include(git_repo) }

      context "that are malformed" do
        before do
          write_recipe_books_file @config, <<-STRING
            git    '#{malformed_git_repo}'
            github '#{malformed_git_repo}'
            git    '#{git_repo}'
          STRING
          
          @output = capture_stdout do
            KitchenBoy::RecipeBooks.new(@config).load_recipe_books
          end
        end

        it { expect(@config.recipe_books).not_to include(malformed_git_repo) }
        it { expect(@config.recipe_books).to include(git_repo) }
        it { expect(@output).to include("Is this git repo correct?") }
        it { expect(@output).to include("Is this github shorthand correct?") }
      end
    end

    context "when there are repetitive git repositories" do
      before do
        write_recipe_books_file @config, <<-STRING
          git    '#{git_repo}'
          git    '#{git_repo}'
        STRING

        KitchenBoy::RecipeBooks.new(@config).load_recipe_books
      end

      it { expect(@config.recipe_books.count).to eq(2) }
    end

    context "when there is directory" do
      before do
        write_recipe_books_file @config, <<-STRING
          directory '/users'
        STRING

        KitchenBoy::RecipeBooks.new(@config).load_recipe_books
      end

      context "that can't be read"
    end

  end

end
