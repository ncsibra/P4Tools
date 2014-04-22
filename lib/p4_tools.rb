require 'P4'
require_relative 'p4tools/environment'
require_relative 'p4tools/p4_delegate'
require_relative 'p4tools/utils/utils'
require_relative 'p4tools/utils/command_utils'
require_relative 'p4tools/utils/window_manager'
require_relative 'p4tools/parsers/command_parser'
require_relative 'p4tools/parsers/trollop_custom'
require_relative 'p4tools/parsers/command_options'
require_relative 'p4tools/parsers/command_entry'

module P4Tools

  # @param [Array<String>] args
  # @return [void]
  def self.run(args=ARGV)
    entries = CommandParser.new(args).parse
    global_arguments = entries.shift.arguments

    setup_perforce_config(global_arguments[:p4config])
    create_perforce_connection

    begin
      run_commands(entries)
      WindowManager.refresh if global_arguments[:refresh]
    ensure
      @p4.disconnect
    end
  end

  # @param [CommandOptions] opts
  # @return [void]
  def self.set_options(opts)
    opts.set do
      help 'Simple command line tool to run custom perforce actions through subcommands.'
      help 'For more information, please check the help page of the command.'
      help ''
      help "Available subcommands are:\n  #{SUB_COMMANDS.join("\n  ")}"
      help ''
      help 'Global options:'
      help ''
      arg :refresh, 'Send a refresh keystroke(F5) to the Visual Client.', :short => '-r'
      arg :p4config, 'Absolute path of the P4CONFIG file.', :short => '-p', :type => :string
    end
  end

  # @return [P4]
  def self.connection
    @p4
  end


  class << self
    private

    # @return [void]
    def create_perforce_connection
      @p4 = P4.new
      @p4.connect
    end

    # @param [Hash<Module, Hash<Symbol, Object>>] commands
    # @return [void]
    def run_commands(entries)
      entries.each do |entry|
        command = entry.command
        arguments = entry.arguments

        command.run(arguments)
      end
    end

    # @param [String] config_path
    # @return [void]
    def setup_perforce_config(config_path)
      if config_path
        ENV['P4CONFIG'] = config_path
      elsif ENV['P4CONFIG'].nil?
        ENV['P4CONFIG'] = CONFIG_ROOT + '/p4.ini'
      end
    end
  end


  if __FILE__ == $PROGRAM_NAME
    run
  end
end