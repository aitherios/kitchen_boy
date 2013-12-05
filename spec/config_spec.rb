require 'spec_helper'

describe KitchenBoy::Config do
  before { @config = KitchenBoy::Config.new home_dir }
  after { FileUtils.rm_rf Dir.glob(File.join(home_dir, '*')) }

  describe ".bootstrap_home_dir" do

    context "when passing a valid home_dir" do
      let(:home_dir) { $home_dir }
      it { expect(@config.bootstrap_home_dir).to be(true) }
      it do
        @config.bootstrap_home_dir
        expect(Dir).to exist($home_dir)
      end
    end

    context "when passing an invalid home_dir" do
      let(:home_dir) { '/invalid_home_dir' }
      it { expect(@config.bootstrap_home_dir).to be(false) }
    end

    context "when home_dir and recipe_books file exists" do
      let(:home_dir) { $home_dir }
      before do
        Dir.chdir(home_dir) do
          File.open('recipe_books', 'w') { |f| f.write "github 'aitherios/kitchen_boy_recipe_book'" }
        end
      end

      it "should keep the recipe books file" do
        @config.bootstrap_home_dir 
        Dir.chdir(home_dir) do
          expect(IO.read 'recipe_books').to eq("github 'aitherios/kitchen_boy_recipe_book'")
        end
      end
    end
  end
end
