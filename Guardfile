interactor :off

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
  watch('spec/spec_helper.rb')       { 'spec' }
  watch(%r{^lib/(.+)\.rb$})          { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/dsl/(.+)\.rb$})      { |m| "spec/dsl/#{m[1]}_spec.rb" }
end

guard :cucumber do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^bin/.+$})                       { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'features'
  end
end

guard :bundler do
  watch(/^.+\.gemspec/)
end
