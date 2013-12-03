Then /^the help message should be present$/ do
  step %(the output should contain "--help")
end

Then /^the version should be present$/ do
  step %(the output should match /version\s*[0-9]+\.[0-9]+\.[0-9]/)
end

Then(/^the updated message should be present$/) do
  step %(the output should contain "Updated recipe book(s)!")
end

Given(/^kitchen_boy home directory is invalid$/) do
  @home_dir = '/asonthuaonethasenot'
end

Then(/^the updating error message should be present$/) do
  step %(the output should contain "Error creating or accessing kitchen_boy home dir: #{@home_dir}")
end
