require 'P4'
require_relative 'perforce_tools/environment'
require_relative 'perforce_tools/utils/utils'
require_relative 'perforce_tools/utils/command_utils'
require_relative 'perforce_tools/parsers/command_parser'
require_relative 'perforce_tools/perforce/dummy_perforce'
require_relative 'perforce_tools/utils/window_manager'

module PerforceTools

  def self.run(args=ARGV)
    arguments = CommandParser.new(args).parse
    global_arguments = arguments.delete(PerforceTools)

    setup_perforce_config(global_arguments)
    create_perforce_connection(global_arguments[:dry_run])

    begin
      run_commands(arguments)
      WindowManager.refresh if global_arguments[:refresh]
    ensure
      @perforce.disconnect
    end
  end

  def self.set_options(opts)
    opts.set do
      arg :dry_run, "Doesn't call any perforce command, just prints the method name and arguments.", :short => '-d'
      arg :refresh, "Send a refresh keystroke(F5) to the Visual Client.", :short => '-r'
      arg :p4config, "Absolute path of the P4CONFIG file.", :short => '-p', :type => :string
    end
  end

  def self.connection
    @perforce
  end


  class << self
    private

    def create_perforce_connection(dry_run)
      @perforce = dry_run ? DummyPerforce.new : P4.new
      @perforce.connect
    end

    def run_commands(commands)
      commands.each_pair do |command, arguments|
        command.run(arguments)
      end
    end

    def setup_perforce_config(arguments)
      if arguments[:p4config]
        ENV['P4CONFIG'] = arguments[:p4config]
      elsif ENV['P4CONFIG'].nil?
        ENV['P4CONFIG'] = CONFIG_ROOT + '/p4.ini'
      end
    end
  end


  if __FILE__ == $PROGRAM_NAME
    run
  end
end