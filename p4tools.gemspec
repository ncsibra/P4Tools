require './lib/p4tools/spec'

Gem::Specification.new do |gem|
  gem.name               = P4Tools::PROJECT_NAME
  gem.version            = P4Tools::VERSION

  gem.author = 'Norbert Csibra'
  gem.email    = 'napispam@gmail.com'
  gem.homepage = 'https://github.com/ncsibra/P4Tools'
  gem.summary = 'Simple command line tool to run custom perforce commands.'
  gem.description = 'Simple command line tool to run custom perforce commands. '
  gem.files = `git ls-files`.split($/).delete_if {|file| file =~ %r{^gem/|^lib/commands/custom/}}
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.require_paths = ['lib']
  gem.license = 'GPL-2'
  
  gem.add_runtime_dependency('P4Ruby-mingwx86', '~> 2014.1')

  gem.add_development_dependency('rake', '~> 0')
end