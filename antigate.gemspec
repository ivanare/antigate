# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "antigate/version"

Gem::Specification.new do |s|
  s.name        = "antigate"
  s.version     = Antigate::VERSION
  s.authors     = ["Ivan Aryutkin"]
  s.email       = ["iivanare@gmail.com"]
  s.homepage    = "https://github.com/ivanare/antigate"
  s.summary     = %q{Antigate wrapper}
  s.description = %q{Wrapper for Antigate API}

  s.rubyforge_project = "antigate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
