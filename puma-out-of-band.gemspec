# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'puma/out_of_band/version'

Gem::Specification.new do |spec|
  spec.authors       = ['Arthur Holstvoogd']
  spec.description   = 'A puma plugin add a out-of-band worker'
  spec.email         = 'arthurholstvoogd@mailbox.org'
  spec.homepage      = 'https://github.com/holstvoogd/puma-out-of-band'
  spec.license       = 'MIT'
  spec.name          = 'puma-out-of-band'
  spec.require_paths = ['lib']
  spec.summary       = 'Out-of-band worker'
  spec.version       = Puma::OutOfBand::VERSION

  files              = %w[CHANGELOG.md LICENSE README.md Rakefile lib]
  spec.files         = `git ls-files -z #{files.join(' ')}`.split("\0")

  spec.add_runtime_dependency 'puma', '~> 4.0'

  spec.add_development_dependency 'bundler',  '~> 0'
  spec.add_development_dependency 'minitest', '~> 0'
  spec.add_development_dependency 'rake',     '>= 12.3.3'
  spec.add_development_dependency 'rubocop',  '>= 0.49.0'
end
