# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miami_dade_geo/version'

Gem::Specification.new do |spec|
  spec.name          = "miami_dade_geo"
  spec.version       = MiamiDadeGeo::VERSION
  spec.authors       = ["Bryce Kerley", "Josef Diago"]
  spec.email         = ["bkerley@brycekerley.net", "josef.diago@gmail.com"]

  spec.summary       = %q{Geospatial utility API for Miami-Dade County}
  spec.description   = %q{Rubyist-friendly geospatial utilities for Miami-Dade County}
  spec.homepage      = "https://github.com/bkerley/miami_dade_geo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency 'webmock', "~> 2.1"
  spec.add_development_dependency 'guard-rspec', "~> 4.7"

  spec.add_dependency 'savon', '~> 2.11.1'
end
