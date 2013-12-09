Given(/^an inexistent kitchen_boy home directory$/) do
  @home_dir = File.expand_path(File.join(@dirs + ['.kitchen_boy']))

  FileUtils.mkdir_p(@dirs[0])
  FileUtils.rm_rf(@home_dir)
end

Given(/^a created kitchen_boy home directory$/) do
  @home_dir = File.expand_path(File.join(@dirs + ['.kitchen_boy']))

  FileUtils.mkdir_p(@home_dir)

  default_repo_dir = File.join(@home_dir, 'https_github_com_aitherios_kitchen_boy_recipe_book_git')
  
  FileUtils.mkdir_p(default_repo_dir)
  
  File.open(File.join(@home_dir, 'recipe_books'), 'w') { |f| f.write "#" }
end

Given(/^an invalid kitchen_boy home directory$/) do
  @home_dir = '/asonthuaonethasenot'
end

When(/^I run kitchen_boy update$/) do
  step %(I run `kitchen_boy --home-dir="#{@home_dir}" update`)
end

When(/^I run kitchen_boy cook "([^"]*)"$/) do |file|
  step %(I run `kitchen_boy --home-dir="#{@home_dir}" cook #{file}`)
end

Then(/^kitchen_boy home directory exists/) do
  expect(Dir).to exist(@home_dir)
end

Then(/^kitchen_boy recipe_books file exists/) do
  expect(File).to exist(File.join(@home_dir, 'recipe_books'))
end

Then(/^kitchen_boy default recipe book was downloaded/) do
  expect do
    Git.open(File.join(
        @home_dir,
        'https_github_com_aitherios_kitchen_boy_recipe_book_git'))
  end.not_to raise_error
end
