# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'montage/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-montage"
  spec.version       = Montage::VERSION
  spec.authors       = ["dphaener"]
  spec.email         = ["dphaener@gmail.com"]

  spec.summary       = %q{A Ruby wrapper for the Monatge REST API}
  spec.description   = %q{A better description is coming...}
  spec.homepage      = "https://github.com/EditLLC/ruby-montage"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "shoulda-context", "~> 1.0"
  spec.add_development_dependency "mocha", "~> 1.1"
  spec.add_development_dependency "simplecov", "~> 0.9.1"
  spec.add_development_dependency "coveralls"

  spec.add_runtime_dependency "faraday", "~> 0.9"
  spec.add_runtime_dependency "faraday_middleware", "~> 0.9"
  spec.add_runtime_dependency "json", "~> 1.8"
  spec.add_runtime_dependency "minitest", "~> 5.5.0"
  spec.add_runtime_dependency "net-http-persistent"
end
