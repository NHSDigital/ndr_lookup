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
  spec.homepage      = 'https://github.com/PublicHealthEngland/ndr_lookup'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activeresource', '< 7'
  spec.add_dependency 'activesupport', '< 7'
  spec.add_dependency 'httpi', '~> 2.4'
  spec.add_dependency 'rubyntlm', '~> 0.6'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'ndr_dev_support', '>= 6.0', '< 8.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'webmock'

  spec.required_ruby_version = '>= 2.7'
end
