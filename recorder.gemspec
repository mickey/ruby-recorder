# -*- encoding: utf-8 -*-
require File.expand_path('../lib/recorder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Bensoussan"]
  gem.email         = ["mbensoussan.is@gmail.com"]
  gem.description   = %q{Recorder dumps the result of your ruby code to a YAML file for faster tests or to compare the result between two execution.}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ruby-recorder"
  gem.require_paths = ["lib"]
  gem.version       = Recorder::VERSION

  gem.add_dependency('differ')
  gem.add_dependency('colored')
end
