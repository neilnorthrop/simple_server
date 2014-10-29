# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name             = 'Simple_Server_Example'
  s.version          = "0.0.1"
  s.files            = `git ls-files`.split($/)
  s.executables      = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files       = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.date             = '2014-10-15'
  s.summary          = "Simple Server Example"
  s.description      = "A simple web server by me"
  s.authors          = ["Neil Northrop"]
  s.email            = 'nnorthrop@gmail.com'
  s.homepage         = 'http://www.example.com'
  s.license          = 'MIT'
end