ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
lib = File.join(File.expand_path(File.dirname(__FILE__)),'..','lib')
$:.unshift(lib) unless $:.include?(lib)

require 'kitchen_boy'
require 'fileutils'



RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    $home_dir = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'tmp', 'fake_home')
    FileUtils.rm_rf($home_dir) if Dir.exists?($home_dir)
    Dir.mkdir($home_dir)
  end

  config.after(:suite) do
    FileUtils.rm_rf($home_dir) if Dir.exists?($home_dir)
  end
end
