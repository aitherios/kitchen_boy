Then /^the help message should be present$/ do
  step %(the output should contain "--help")
end

Then /^the version should be present$/ do
  step %(the output should match /version\s*[0-9]+\.[0-9]+\.[0-9]/)
end
