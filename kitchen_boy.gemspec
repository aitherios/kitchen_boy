# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'kitchen_boy/version'

Gem::Specification.new do |s|
  s.name          = 'kitchen_boy'
  s.version       = KitchenBoy::VERSION
  s.authors       = ['Renan Mendes Carvalho']
  s.email         = ['aitherios@gmail.com']
  s.homepage      = 'https://github.com/aitherios/kitchen_boy'
  s.summary       = "Run, write, store and share recipes to run on your projects."
  s.description   = "kitchen_boy is a way to package and run project recipes. " +
                    "Installing a gem and running default generators or " +
                    "customizing configuration to fit your needs."
  s.licenses      = ['MIT', 'GPL-3']
  s.platform      = Gem::Platform::RUBY

  s.files         = `git ls-files app lib`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_development_dependency 'bundler',     '~> 1.3'
  s.add_development_dependency 'rake',        '~> 10.1'
  s.add_development_dependency 'rdoc',        '~> 4.0'
  s.add_development_dependency 'aruba',       '~> 0.5'
  s.add_development_dependency 'rspec',       '>= 3.0.0.beta1'
  s.add_development_dependency 'gem-release', '~> 0.7.1'

  s.add_dependency             'gli',         '~> 2.8'
  s.add_dependency             'rainbow',     '~> 1.1.4'
  s.add_dependency             'git',         '~> 1.2.6'
end
