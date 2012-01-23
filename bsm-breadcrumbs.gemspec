# -*- encoding: utf-8 -*-
require File.expand_path("../lib/breadcrumbs/version", __FILE__)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "bsm-breadcrumbs"
  s.summary     = "Breadcrumbs is a simple plugin that adds a `breadcrumbs` object to controllers and views."
  s.version     = Breadcrumbs::Version::STRING

  s.authors     = ["Nando Vieira", "Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/breadcrumbs"

  s.require_path = 'lib'
  s.files        = Dir['README.rdoc', 'lib/**/*']

  s.add_dependency "actionpack", ">= 3.0.0"
  s.add_dependency "activemodel", ">= 3.0.0"
  s.add_development_dependency "rake"
end
