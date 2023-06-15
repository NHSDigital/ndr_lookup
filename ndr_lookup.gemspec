lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ndr_lookup/version'

Gem::Specification.new do |spec|
  spec.name          = 'ndr_lookup'
  spec.version       = NdrLookup::VERSION
  spec.authors       = ['NCRS Development Team']
  spec.email         = []

  spec.summary       = 'NDR Lookup library'
  spec.description   = 'NDR library to consume lookup data APIs'
  spec.homepage      = 'https://github.com/NHSDigital/ndr_lookup'
  spec.license       = 'MIT'

  gem_files        = %w[CHANGELOG.md CODE_OF_CONDUCT.md LICENSE.txt README.md Rakefile
                        app config db lib]
  spec.files       = `git ls-files -z`.split("\x0").
                     select { |f| gem_files.include?(f.split('/')[0]) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activeresource', '>= 6.0', '< 7'
  spec.add_dependency 'activesupport', '>= 6.1', '< 7.1'
  spec.add_dependency 'httpi', '~> 2.4'
  spec.add_dependency 'rubyntlm', '~> 0.6'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'ndr_dev_support', '>= 6.0', '< 8.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'webmock'

  spec.required_ruby_version = '>= 3.0'
end
