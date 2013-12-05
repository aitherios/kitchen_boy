require 'spec_helper'

describe KitchenBoy::RecipeBook do
  before { @config = KitchenBoy::Config.new $home_dir }
  let(:spoon_knife) { 'https://github.com/octocat/Spoon-Knife.git' }

  describe ".directory_name" do
    before { @recipe_book = KitchenBoy::RecipeBook.new(@config, spoon_knife) }
    subject { @recipe_book.directory_name }
    it { should eq('https_github_com_octocat_spoon-knife_git') }
  end
  
  describe ".update" do
    context "when the git repository was added for the first time" do
      before { @recipe_book = KitchenBoy::RecipeBook.new(@config, spoon_knife) }
    end
    context "when the git repository is beeing updated"
    context "when the directory is given"
  end
end
