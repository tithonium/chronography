# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chronography/version'

Gem::Specification.new do |spec|
  spec.name          = "chronography"
  spec.version       = Chronography::VERSION
  spec.authors       = ["Martin Tithonium"]
  spec.email         = ["martian@midgard.org"]
  spec.description   = %q{Multi-system date/time representation, my way.}
  spec.summary       = %q{Multi-system date/time representation, my way.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "defined"
  spec.add_dependency "ruby-units"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "growl"
end
