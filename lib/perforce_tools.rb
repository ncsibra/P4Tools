require 'P4'
require_relative 'perforce_tools/environment'
require_relative 'perforce_tools/utils/utils'
require_relative 'perforce_tools/parsers/command_parser'
require_relative 'perforce_tools/perforce/dummy_perforce'
require_relative 'perforce_tools/utils/window_manager'

module PerforceTools
  def self.run_with_arguments(args=ARGV)
    arguments = CommandParser.new(args).parse
    global_arguments = arguments.delete(PerforceTools)

    setup_perforce_config(global_arguments)
    perforce = create_perforce_object(global_arguments[:dry_run])
    perforce.connect

    begin
      run_commands(arguments, perforce)
      WindowManager.refresh if global_arguments[:refresh]
    ensure
      perforce.disconnect
    end
  end

  def self.create_perforce_object(dry_run)
    dry_run ? DummyPerforce.new : P4.new
  end

  def self.run_commands(commands, perforce)
    commands.each_pair do |command, arguments|
      command.run(arguments, perforce)
    end
  end

  def self.setup_perforce_config(arguments)
    if arguments[:p4config]
      ENV['P4CONFIG'] = arguments[:p4config]
    elsif ENV['P4CONFIG'].nil?
      ENV['P4CONFIG'] = CONFIG_ROOT + '/p4.ini'
    end
  end

  def self.set_options(opts)
    opts.set do
      arg :dry_run, "Doesn't call any perforce command, just prints the method name and arguments.", :short => '-d'
      arg :refresh, "Send a refresh keystroke(F5) to the Visual Client.", :short => '-r'
      arg :p4config, "Absolute path of the P4CONFIG file.", :short => '-p', :type => :string
    end
  end


  if __FILE__ == $PROGRAM_NAME
    run_with_arguments
  end
end