require 'rake'
require './lib/p4tools/spec'

def gem_name
  @gem_name ||= "#{P4Tools::PROJECT_NAME}-#{P4Tools::VERSION}"
end

def build_gem
  system("gem build #{P4Tools::PROJECT_NAME}.gemspec")
end

def delete_gem
  File.delete("#{gem_name}.gem")
end

task :check_version do
  abort 'Update version before release!' unless %x{git tag -l #{gem_name}}.empty?
end

task :release => [:check_version] do
  if build_gem
    system "git tag #{gem_name}"
    system 'git push --tags'
    system "gem push #{gem_name}.gem"

    delete_gem
  end
end

task :update do
  if build_gem
    system "gem install #{gem_name}.gem"

    delete_gem
  end
end

