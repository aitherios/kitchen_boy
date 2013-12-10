require 'simplecov'
SimpleCov.command_name 'Cucumber'
require 'coveralls'

require 'aruba/cucumber'
require 'fileutils'
require 'git'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_PATH = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  @aruba_timeout_seconds = 10
  @dirs = [File.expand_path(File.join('..', '..', '..', 'tmp', 'fake_home'), __FILE__)]
  Dir.mkdir(@dirs[0]) unless Dir.exist?(@dirs[0])
  ENV['RUBYLIB'] = LIB_PATH + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
end

After do
  ENV['RUBYLIB'] = @original_rubylib
  FileUtils.rm_rf(@dirs[0])
end
