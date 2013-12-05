require 'spec_helper'

describe KitchenBoy::RecipeBook do
  let(:config) { KitchenBoy::Config.new $home_dir }
  let(:spoon_knife_repo) { 'https://github.com/octocat/Spoon-Knife.git' }
  let(:spoon_knife_recipe_book) { KitchenBoy::RecipeBook.new(config, spoon_knife_repo) }
  let(:directory) { File.join($home_dir, 'fake_dir') }
  let(:directory_recipe_book) { KitchenBoy::RecipeBook.new(config, directory) }
  let(:file) { File.join(directory, 'teste') }
  
  describe ".directory_name" do
    context "when URI" do
      subject { spoon_knife_recipe_book.directory_name }
      it { should eq('https_github_com_octocat_spoon-knife_git') }
    end

    context "when a directory" do
      subject { KitchenBoy::RecipeBook.new(config, '/teste/teste').directory_name }
      it { should eq('teste_teste') }
    end
  end

  describe ".directory_path" do
    context "when URI" do
      subject { spoon_knife_recipe_book.directory_path }
      it { should eq(File.join(config.home_dir, spoon_knife_recipe_book.directory_name)) }
    end

    context "when a directory" do
      before { Dir.mkdir(directory) unless Dir.exist?(directory) }
      subject { directory_recipe_book.directory_path }
      it { should eq(File.join(config.home_dir, directory_recipe_book.directory_name)) }
    end
  end
  
  describe ".update" do
    context "when the git repository was added for the first time" do
      before do
        FileUtils.rm_rf(spoon_knife_recipe_book.directory_path)
        spoon_knife_recipe_book.update
      end
      
      it { expect { Git.open(spoon_knife_recipe_book.directory_path) }.not_to raise_error }
    end
    
    context "when the git repository is beeing updated" do
      before do
        FileUtils.rm_rf(spoon_knife_recipe_book.directory_path)
        Git.clone(spoon_knife_repo, spoon_knife_recipe_book.directory_name, path: $home_dir)
        spoon_knife_recipe_book.update
      end
      
      it { expect { Git.open(spoon_knife_recipe_book.directory_path) }.not_to raise_error }
    end

    context "when the directory is given" do
      before do
        Dir.mkdir(directory) unless Dir.exist?(directory)
        File.open(file, 'w') { |f| f.write 'teste' }
        KitchenBoy::RecipeBook.new(config, directory).update
      end
      
      it { expect(Dir).to exist(File.join(config.home_dir, 'fake_dir')) }
      it { expect(File).to exist(File.join(config.home_dir, 'fake_dir', 'teste')) }
    end
    
    context "when the repository is not a git repository"
  end
end
