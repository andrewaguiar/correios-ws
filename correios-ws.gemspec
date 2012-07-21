# -*- encoding: utf-8 -*-
require File.expand_path('../lib/correios-ws/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Andrew S Aguiar']
  gem.email         = ['andrewaguiar6@gmail.com']
  gem.description   = 'correios-ws uses correios web-services SOAP to calculate shipping'
  gem.summary       = 'correios shipping calculation using SOAP'
  gem.homepage      = 'http://www.github.com/andrewaguiar/correios-ws'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'correios-ws'
  gem.require_paths = ['lib']
  gem.version       = Correios::VERSION

  gem.add_dependency 'soap4r'
end