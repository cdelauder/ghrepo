# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghrepo/version'

Gem::Specification.new do |spec|
  spec.name          = "ghrepo"
  spec.version       = Ghrepo::VERSION
  spec.authors       = ["Chris DeLauder", "Sam Samskies", "Kelly Puckett", "Brantley Beaird"]
  spec.email         = ["cdelauder@gmail.com"]
  spec.description   = %q{Create a GitHub repo from the command line}
  spec.summary       = %q{Create a Github repo from the command line}
  spec.homepage      = "https://github.com/cdelauder/ghrepo"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end

