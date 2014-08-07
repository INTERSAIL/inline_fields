$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "inline_fields/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "inline_fields"
  s.version     = InlineFields::VERSION
  s.authors     = ["Intersail Engineering"]
  s.email       = ["cristiano.boncompagni@intersail.it"]
  s.homepage    = "http://www.intersail.it"
  s.summary     = "Summary of InlineFields."
  s.description = "Description of InlineFields."
  s.license     = "MIT"

  s.files = Dir["{app,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4"
  s.add_dependency 'simple_form'
end
