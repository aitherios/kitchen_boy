require 'spec_helper'

describe KitchenBoy::RecipeBook do
  let(:config) { KitchenBoy::Config.new $home_dir }

  let(:spoon_knife_repo) { 'https://github.com/octocat/Spoon-Knife.git' }
  let(:spoon_knife_recipe_book) { KitchenBoy::RecipeBook.new(config, spoon_knife_repo) }

  let(:directory) { File.join($home_dir, 'fake_dir') }
  let(:file) { File.join(directory, 'test') }
  let(:directory_recipe_book) { KitchenBoy::RecipeBook.new(config, directory) }

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

  context "with kitchen_boy home populated by recipes" do
    let(:source_dir) { directory_recipe_book.directory_path }
    let(:recipe_rb) { File.expand_path(File.join(source_dir, 'recipe.rb')) }
    let(:inside_dir) { File.join(source_dir, 'recipe') }
    let(:inside_recipe_rb) { File.expand_path(File.join(inside_dir, 'recipe.rb')) }
    let(:dont_find) { File.expand_path(File.join(inside_dir, 'other_recipe.rb')) }
    
    before do
      FileUtils.mkdir_p(source_dir)
      FileUtils.mkdir_p(inside_dir)
      File.open(recipe_rb, 'w') { |f| f.write 'File' }
      File.open(inside_recipe_rb, 'w') { |f| f.write 'File' }
      File.open(dont_find, 'w') { |f| f.write 'File' }
    end
    after { FileUtils.rm_rf(source_dir) }

    describe ".find" do
      describe ".find('recipe')" do
        subject { directory_recipe_book.find('recipe') }
        it { should include( KitchenBoy::Recipe.new(recipe_rb, directory_recipe_book) ) }
        it { should include( KitchenBoy::Recipe.new(inside_recipe_rb, directory_recipe_book) ) }
        it { should_not include( KitchenBoy::Recipe.new(inside_dir, directory_recipe_book) ) }
        it { should_not include( KitchenBoy::Recipe.new(dont_find, directory_recipe_book) ) }
        it { expect(subject.size).to eq(2) }
      end

      describe ".find('Recipe')" do
        subject { directory_recipe_book.find('Recipe') }
        it { should include( KitchenBoy::Recipe.new(recipe_rb, directory_recipe_book) ) }
      end

      describe ".find(' recipe ')" do
        subject { directory_recipe_book.find(' recipe ') }
        it { should include( KitchenBoy::Recipe.new(recipe_rb, directory_recipe_book) ) }        
      end

      describe ".find('.*')" do
        subject { directory_recipe_book.find('.*') }
        it { expect(subject.size).to eq(0) }
      end
    end
  end
end
