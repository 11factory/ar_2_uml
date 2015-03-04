# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar_2_uml/version'

Gem::Specification.new do |spec|
  spec.name          = "ar_2_uml"
  spec.version       = Ar2Uml::VERSION
  spec.authors       = ["Laurent Cobos"]
  spec.email         = ["laurent@11factory.fr"]

  spec.summary       = %q{Active Record model to UML dotfile}
  spec.homepage      = "https://github.com/11factory/ar_2_uml"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "mocha", "~> 1.1.0"
  spec.add_development_dependency "minitest"
  
  spec.add_runtime_dependency "activerecord", ">= 3.0.0"
end
