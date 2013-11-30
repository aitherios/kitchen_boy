# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'kitchen_boy/version'

Gem::Specification.new do |s|
  s.name          = "kitchen_boy"
  s.version       = KitchenBoy::VERSION
  s.authors       = ["Renan Mendes Carvalho"]
  s.email         = ["aitherios@gmail.com"]
  s.homepage      = "https://github.com//kitchen_boy"
  s.summary       = "TODO: summary"
  s.description   = "TODO: description"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
end
