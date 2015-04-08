# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jquery_popup_uploader/version'

Gem::Specification.new do |spec|
  spec.name          = "jquery_popup_uploader"
  spec.version       = JqueryPopupUploader::VERSION
  spec.authors       = ["Julien Seitz"]
  spec.email         = ["julien.seitz@gmail.com"]
  spec.summary       = %q{Gem that provides simple_form input file upload via popup based jquery/carrierwave mechanism}
  #spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "rails", ">= 4.0.0"

  spec.add_dependency "simple_form", "~> 3.1"
  spec.add_dependency "carrierwave"
end
