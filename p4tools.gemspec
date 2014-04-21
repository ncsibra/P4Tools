Gem::Specification.new do |gem|
  gem.name               = 'P4Tools'
  gem.version            = '0.1'

  gem.author = ['Norbert Csibra']
  gem.email    = 'napispam@gmail.com'
  gem.homepage = 'https://github.com/ncsibra/P4Tools'
  gem.summary = 'Simple command line tool to run custom perforce actions.'
  gem.description = %q{Simple command line tool to run custom perforce actions}
  gem.files = `git ls-files`.split($/)
  gem.require_paths = ["lib"]
  
  gem.add_runtime_dependency('P4Ruby-mingwx86', "~> 2014.1")
end