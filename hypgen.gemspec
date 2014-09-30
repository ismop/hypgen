# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hypgen/version'

Gem::Specification.new do |spec|
  spec.name          = 'hypgen'
  spec.version       = Hypgen::VERSION
  spec.authors       =  [
                          'Marek Kasztelnik',
                          'Maciej Pawlik',
                          'Maciej Malawski'
                        ]
  spec.email         =  [
                          'mkasztelnik@gmail.com',
                          'm.pawlik@cyfronet.pl',
                          'malawski@agh.edu.pl'
                        ]
  spec.summary       = %q{ISMOP experiment runner}
  spec.description   = %q{ISMOP experiment runner.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'sidekiq'
  spec.add_dependency 'faraday'
  spec.add_dependency 'grape'
  spec.add_dependency 'puma'
  spec.add_dependency 'recursive-open-struct'
  spec.add_dependency 'rack-cors'
end