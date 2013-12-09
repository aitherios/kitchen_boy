require 'spec_helper'

describe KitchenBoy::DSL::RecipeBooks do
  let(:config) { KitchenBoy::Config.new $home_dir }
  let(:github_repo) { 'https://github.com/aitherios/kitchen_boy_recipe_book.git' }
  let(:github_shorthand) { 'aitherios/kitchen_boy_recipe_book' }
  let(:git_repo) { 'https://aitherios@bitbucket.org/aitherios/kitchen_boy_recipe_book.git' }
  let(:malformed_git_repo) { '://aitherios @bitbucket .org/aith' }

  describe ".sources" do
    context "when there is git repositories" do
      before do
        write_recipe_books_file config, <<-STRING
          git    '#{git_repo}'
          github '#{github_shorthand}'
        STRING
      end

      subject {  KitchenBoy::DSL::RecipeBooks.new(config).sources }
      it { should include(github_repo) }
      it { should include(git_repo) }

      context "that are malformed" do
        before do
          write_recipe_books_file config, <<-STRING
            git    '#{malformed_git_repo}'
            github '#{malformed_git_repo}'
            git    '#{git_repo}'
            git    '#{github_shorthand}'
          STRING
          
          @output = capture_stdout do
            @sources = KitchenBoy::DSL::RecipeBooks.new(config).sources
          end
        end

        it { expect(@sources).not_to include(malformed_git_repo) }
        it { expect(@sources).not_to include(github_shorthand) }
        it { expect(@sources).to include(git_repo) }
        it { expect(@output).to include("is this git repo correct?") }
        it { expect(@output).to include("is this github shorthand correct?") }
      end
    end

    context "when there are repetitive git repositories" do
      before do
        write_recipe_books_file config, <<-STRING
          git    '#{git_repo}'
          git    '#{git_repo}'
        STRING

        @sources = KitchenBoy::DSL::RecipeBooks.new(config).sources
      end

      it { expect(@sources.count).to eq(1) }
    end

    context "when there is readable directory" do
      let(:readonly_dir) { File.join($home_dir, 'readonly_dir') }
      let(:unreadable_dir) { File.join($home_dir, 'unreadable_dir') }
      let(:inexistent_dir) { File.join($home_dir, 'inexistent_dir') }
      
      before do
        FileUtils.mkdir_p(readonly_dir, mode: 0444)
        
        write_recipe_books_file config, <<-STRING
          directory '#{readonly_dir}'
        STRING
      end

      after do
        FileUtils.chmod(0777, readonly_dir)
        FileUtils.rm_rf(readonly_dir)
      end

      subject { KitchenBoy::DSL::RecipeBooks.new(config).sources }
      it { should include(readonly_dir) }

      context "that can't be accessed" do
        before do
          FileUtils.mkdir_p(unreadable_dir, mode: 0000)
          
          write_recipe_books_file config, <<-STRING
            directory '#{unreadable_dir}'
            directory '#{inexistent_dir}'
          STRING

          @output = capture_stdout do
            @sources = KitchenBoy::DSL::RecipeBooks.new(config).sources
          end
        end

        after do
          FileUtils.chmod(0777, unreadable_dir)
          FileUtils.rm_rf(unreadable_dir)
        end

        it { expect(@sources).not_to include(inexistent_dir) }
        it { expect(@sources).not_to include(unreadable_dir) }
        it { expect(@output).to include("not readable: #{unreadable_dir}") }
        it { expect(@output).to include("inexistent: #{inexistent_dir}") }
      end
    end

  end

end
