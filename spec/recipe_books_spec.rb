require 'spec_helper'

describe KitchenBoy::DSL::RecipeBooks do
  before { @config = KitchenBoy::Config.new $home_dir }
  let(:github_repo) { 'https://github.com/aitherios/kitchen_boy_recipe_book.git' }
  let(:github_shorthand) { 'aitherios/kitchen_boy_recipe_book' }
  let(:git_repo) { 'https://aitherios@bitbucket.org/aitherios/kitchen_boy_recipe_book.git' }
  let(:malformed_git_repo) { '://aitherios @bitbucket .org/aith' }

  describe ".load_recipe_books" do
    context "when there is git repositories" do
      before do
        write_recipe_books_file @config, <<-STRING
          git    '#{git_repo}'
          github '#{github_shorthand}'
        STRING

        KitchenBoy::DSL::RecipeBooks.new(@config).load_recipe_books
      end

      it { expect(@config.sources).to include(github_repo) }
      it { expect(@config.sources).to include(git_repo) }

      context "that are malformed" do
        before do
          write_recipe_books_file @config, <<-STRING
            git    '#{malformed_git_repo}'
            github '#{malformed_git_repo}'
            git    '#{git_repo}'
            git    '#{github_shorthand}'
          STRING
          
          @output = capture_stdout do
            KitchenBoy::DSL::RecipeBooks.new(@config).load_recipe_books
          end
        end

        it { expect(@config.sources).not_to include(malformed_git_repo) }
        it { expect(@config.sources).not_to include(github_shorthand) }
        it { expect(@config.sources).to include(git_repo) }
        it { expect(@output).to include("is this git repo correct?") }
        it { expect(@output).to include("is this github shorthand correct?") }
      end
    end

    context "when there are repetitive git repositories" do
      before do
        write_recipe_books_file @config, <<-STRING
          git    '#{git_repo}'
          git    '#{git_repo}'
        STRING

        KitchenBoy::DSL::RecipeBooks.new(@config).load_recipe_books
      end

      it { expect(@config.sources.count).to eq(2) }
    end

    context "when there is readable directory" do
      let(:readonly_dir) { File.join($home_dir, 'readonly_dir') }
      let(:unreadable_dir) { File.join($home_dir, 'unreadable_dir') }
      let(:inexistent_dir) { File.join($home_dir, 'inexistent_dir') }
      
      before do
        Dir.mkdir(readonly_dir, 0444)
        
        write_recipe_books_file @config, <<-STRING
          directory '#{readonly_dir}'
        STRING

        KitchenBoy::DSL::RecipeBooks.new(@config).load_recipe_books
      end

      after do
        FileUtils.chmod(0777, readonly_dir)
        Dir.rmdir(readonly_dir)
      end

      it { expect(@config.sources).to include(readonly_dir) }

      context "that can't be accessed" do
        before do
          Dir.mkdir(unreadable_dir, 0000)
          
          write_recipe_books_file @config, <<-STRING
            directory '#{unreadable_dir}'
            directory '#{inexistent_dir}'
          STRING

          @output = capture_stdout do
            KitchenBoy::DSL::RecipeBooks.new(@config).load_recipe_books
          end
        end

        after do
          FileUtils.chmod(0777, unreadable_dir)
          Dir.rmdir(unreadable_dir)
        end

        it { expect(@config.sources).not_to include(inexistent_dir) }
        it { expect(@config.sources).not_to include(unreadable_dir) }
        it { expect(@output).to include("not readable: #{unreadable_dir}") }
        it { expect(@output).to include("inexistent: #{inexistent_dir}") }
      end
    end

  end

end
