# -*- encoding: utf-8 -*-
require File.expand_path('../lib/recorder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Bensoussan"]
  gem.email         = ["mbensoussan.is@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "recorder"
  gem.require_paths = ["lib"]
  gem.version       = Recorder::VERSION

  gem.add_dependency('differ')
  gem.add_dependency('colored')
end
