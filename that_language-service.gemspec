# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'that_language/service/version'

Gem::Specification.new do |spec|
  spec.name          = "that_language-service"
  spec.version       = ThatLanguage::Service::VERSION
  spec.authors       = ["Patrick Helm"]
  spec.email         = ["me@patrick-helm.de"]

  spec.summary       = %q{Simple Sinatra wrapper for ThatLanguage.}
  spec.description   = %q{Exposes the ThatLanguage language-detection library over HTTP as eight JSON endpoints. Packaged as a gem rather than an application; the deployment supplies the web server.}
  spec.homepage      = "https://github.com/Deradon/that_language-service"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1"

  spec.metadata = {
    "homepage_uri"          => spec.homepage,
    "source_code_uri"       => spec.homepage,
    "bug_tracker_uri"       => "#{spec.homepage}/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "that_language", "~> 0.1"
  spec.add_dependency "sinatra", "~> 4.2"
  spec.add_dependency "sinatra-contrib", "~> 4.2"

  # No web server is declared as a runtime dependency. This gem is a library;
  # the deployment picks the server and supplies its own rackup. The old
  # `thin ~> 1.6.4` runtime pin is exactly what made this gem uninstallable.
  # `puma` is a development dependency so `config.ru` can be run locally.
  spec.add_development_dependency "pry"
  spec.add_development_dependency "puma", "~> 8.0"
  spec.add_development_dependency "rack-test", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rspec-its", "~> 2.0"
  spec.add_development_dependency "rubocop", "~> 1.88"
end
