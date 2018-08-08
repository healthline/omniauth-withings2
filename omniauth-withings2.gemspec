# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-withings2/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-withings2"
  s.version     = OmniAuth::Withings::VERSION
  s.authors     = ["Daniel Nelson"]
  s.email       = ["daniel@platejoy.com"]
  s.homepage    = "http://github.com/platejoy/omniauth-withings2"
  s.summary     = %q{OmniAuth OAuth2 strategy for Withings}
  s.description = %q{OmniAuth OAuth2 strategy for Withings}

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.4'
end