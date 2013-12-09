require 'spec_helper'

describe KitchenBoy::RecipeBook do
  let(:config) { KitchenBoy::Config.new $home_dir }
  let(:spoon_knife_repo) { 'https://github.com/octocat/Spoon-Knife.git' }
  let(:spoon_knife_recipe_book) { KitchenBoy::RecipeBook.new(config, spoon_knife_repo) }
  let(:directory) { File.join($home_dir, 'fake_dir') }
  let(:directory_recipe_book) { KitchenBoy::RecipeBook.new(config, directory) }
  let(:file) { File.join(directory, 'test') }
  let(:inaccessible_repo) { 'https://test.com/octocat/github.git' }
  let(:inaccessible_repo_recipe_book) { KitchenBoy::RecipeBook.new(config, inaccessible_repo) }

  before { FileUtils.mkdir_p(directory) }
  after { FileUtils.rm_rf(directory) }

  describe ".directory_name" do
    context "when URI" do
      subject { spoon_knife_recipe_book.directory_name }
      it { should eq('https_github_com_octocat_spoon-knife_git') }
    end

    context "when a directory" do
      subject { KitchenBoy::RecipeBook.new(config, '/test/test').directory_name }
      it { should eq('test_test') }
    end
  end

  describe ".directory_path" do
    context "when URI" do
      subject { spoon_knife_recipe_book.directory_path }
      it { should eq(File.join(config.home_dir, spoon_knife_recipe_book.directory_name)) }
    end

    context "when a directory" do
      subject { directory_recipe_book.directory_path }
      it { should eq(File.join(config.home_dir, directory_recipe_book.directory_name)) }
    end
  end
  
  describe ".update" do
    context "when the git repository was added for the first time" do
      before do
        FileUtils.rm_rf(spoon_knife_recipe_book.directory_path)
        @output = capture_stdout do
          spoon_knife_recipe_book.update
        end
      end

      it "expect to fetch the git repo" do
        expect { Git.open(spoon_knife_recipe_book.directory_path) }.not_to raise_error
        expect(@output).to include("Fetching #{spoon_knife_recipe_book.source}")
      end
    end
    
    context "when the git repository is beeing updated" do
      before do
        FileUtils.rm_rf(spoon_knife_recipe_book.directory_path)
        Git.clone(spoon_knife_repo, spoon_knife_recipe_book.directory_name, path: $home_dir)
        @output = capture_stdout do
          spoon_knife_recipe_book.update
        end
      end
      
      it "expect to pull the git repo" do
        expect { Git.open(spoon_knife_recipe_book.directory_path) }.not_to raise_error
        expect(@output).to include("Fetching #{spoon_knife_recipe_book.source}")
      end
    end

    context "whet the git repository is inaccessible" do
      before do
        @output = capture_stdout do
          inaccessible_repo_recipe_book.update
        end
      end
      it { expect(@output).to include("Unable to read this git repository: #{inaccessible_repo}") }
    end

    context "when the directory is given" do
      before do
        File.open(file, 'w') { |f| f.write 'test' }
        @output = capture_stdout do
          KitchenBoy::RecipeBook.new(config, directory).update
        end
      end
      
      it { expect(Dir).to exist(File.join(config.home_dir, 'fake_dir')) }
      it { expect(File).to exist(File.join(config.home_dir, 'fake_dir', 'test')) }
      it { expect(@output).to include("Copying #{directory}") }
    end

    context "when home dir is not writable" do
      before do
        FileUtils.chmod(0555, config.home_dir)
        @output = capture_stdout do
          KitchenBoy::RecipeBook.new(config, directory).update
        end
      end
      after { FileUtils.chmod(0755, config.home_dir) }

      it { expect(@output).to include("Home directory: #{config.home_dir} is not writable!") }
    end
  end
end
