# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/daemon/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-daemon'
  spec.version       = RuboCop::Daemon::VERSION
  spec.authors       = ['Hayato Kawai']
  spec.email         = ['fohte.hk@gmail.com']

  spec.summary       = 'Makes RuboCop faster'
  spec.description   = 'rubocop-daemon is a CLI tool that makes RuboCop faster.'
  spec.homepage      = 'https://github.com/fohte/rubocop-daemon'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.6.0'
end
