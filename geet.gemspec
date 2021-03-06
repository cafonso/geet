# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib', __dir__)

require 'geet/version'

Gem::Specification.new do |s|
  s.name        = 'geet'
  s.version     = Geet::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.0'
  s.authors     = ['Saverio Miroddi']
  s.date        = '2018-02-05'
  s.email       = ['saverio.pub2@gmail.com']
  s.homepage    = 'https://github.com/saveriomiroddi/geet'
  s.summary     = 'Commandline interface for performing SCM (eg. GitHub) operations (eg. PR creation).'
  s.description = 'Commandline interface for performing SCM (eg. GitHub) operations (eg. PR creation).'
  s.license     = 'GPL-3.0'

  s.add_runtime_dependency 'simple_scripting', '~> 0.9.4'
  s.add_runtime_dependency 'temp-fork-tp-filter', '= 0.0.3'

  s.add_development_dependency 'rake', '~> 12.3.0'

  s.files         = `git ls-files`.split("\n")
  s.executables   << 'geet'
  s.require_paths = ['lib']
end
