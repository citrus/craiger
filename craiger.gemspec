# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "craiger/version"

Gem::Specification.new do |s|
  s.name        = "craiger"
  s.version     = Craiger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Spencer Steffen"]
  s.email       = ["spencer@citrusme.com"]
  s.homepage    = "https://github.com/citrus/craiger"
  s.summary     = %q{Craiger is a multi-city craiglist search tool.}
  s.description = %q{Craiger is a multi-city craiglist search tool.}

  s.rubyforge_project = "craiger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "curb",             ">= 0.7.15"
  s.add_dependency "nokogiri",         ">= 1.4.4"
  s.add_dependency "pony",             ">= 1.2"
  s.add_dependency "ruby-progressbar", ">= 0.0.10"
  s.add_dependency "sequel",           ">= 3.23.0"
  s.add_dependency "sqlite3",          ">= 1.3.3"  
  
end
