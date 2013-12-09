require 'spec_helper'

describe KitchenBoy::Cooker do
  let(:config) { KitchenBoy::Config.new $home_dir }
  let(:repo) { File.join(config.home_dir, 'fake_repo') }
  let(:cooker) { KitchenBoy::Cooker.new config }

  before { FileUtils.mkdir_p repo }
  after { FileUtils.rm_rf Dir.glob(File.join(config.home_dir, '*')) }

  describe '.find' do
    context "when the file 'recipe.rb' is inside a repository" do
      let(:file) { File.join(repo, 'recipe.rb') }
      before do
        File.open(file, 'w') { |f| f.write 'File' }
      end

      describe ".find('recipe')" do
        subject { cooker.find('recipe') }
        it { should eq([file]) }
      end

      describe ".find('Recipe')" do
        subject { cooker.find('Recipe') }
        it { should eq([file]) }
      end

      describe ".find(' recipe ')" do
        subject { cooker.find(' recipe ') }
        it { should eq([file]) }
      end
    end

    context "when the file 'recipe.rb' is inside a repository directory" do
      let(:inside_dir) { File.join(repo, 'inside_dir') }
      let(:file) { File.join(inside_dir, 'recipe.rb') }

      before do
        FileUtils.mkdir_p inside_dir
        File.open(file, 'w') { |f| f.write 'File' }
      end

      describe ".find('recipe')" do
        subject { cooker.find('recipe') }
        it { should eq([file]) }
      end
    end

    context "when there are name colisions for 'recipe' in the repository" do
      let(:inside_dir) { File.join(repo, 'recipe') }
      let(:dont_find) { File.join(inside_dir, 'other_recipe.rb') }
      let(:inside_file) { File.join(inside_dir, 'recipe.rb') }
      let(:file) { File.join(repo, 'recipe.rb') }

      before do
        FileUtils.mkdir_p inside_dir
        File.open(dont_find, 'w') { |f| f.write 'File' }
        File.open(inside_file, 'w') { |f| f.write 'File' }
        File.open(file, 'w') { |f| f.write 'File' }
      end

      describe ".find('recipe')" do
        subject { cooker.find('recipe') }
        it { should include(file) }
        it { should include(inside_file) }
        it { should_not include(dont_find) }
        it { expect(subject.size).to eq(2) }
      end

      describe ".find('.*')" do
        subject { cooker.find('.*') }
        it { expect(subject.size).to eq(0) }
      end
    end
  end
  
end
