require 'rake'
require './lib/p4tools/spec'

def gem_name
  @gem_name ||= "#{P4Tools::PROJECT_NAME}-#{P4Tools::VERSION}"
end

task :check_version do
  abort 'Update version before release!' unless %x{git tag -l #{gem_name}}.empty?
end

task :release => [:check_version] do
  if system("gem build #{P4Tools::PROJECT_NAME}.gemspec")
    system "git tag #{gem_name}"
    system 'git push --tags'
    system "gem push #{gem_name}.gem"

    File.delete("#{gem_name}.gem")
  end

end

