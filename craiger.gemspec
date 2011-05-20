# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "craiger/version"

Gem::Specification.new do |s|
  s.name        = "craiger"
  s.version     = Craiger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "craiger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  
  s.add_dependency "eventmachine",    ">= 0.12.10"
  s.add_dependency "em-http-request", ">= 1.0.0.beta.3"
  s.add_dependency "nokogiri",        ">= 1.4.4"
  s.add_dependency "pony",            ">= 1.2"
  
end
