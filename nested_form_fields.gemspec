# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nested_form_fields/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nico Ritsche"]
  gem.email         = ["ncrdevmail@gmail.com"]
  gem.description   = %q{Allows to dynamically add and remove nested has_many association fields in a form.}
  gem.summary       = %q{Allows to dynamically add and remove nested has_many association fields in a form.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nested_form_fields"
  gem.require_paths = ["lib"]
  gem.version       = NestedFormFields::VERSION
end
