require 'P4'
require_relative 'p4tools/environment'
require_relative 'p4tools/utils/utils'
require_relative 'p4tools/utils/command_utils'
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

    create_perforce_connection

    begin
      run_commands(entries)
    ensure
      @p4.disconnect
    end
  end

  # @param [CommandOptions] opts
  # @return [void]
  def self.set_options(opts)
    opts.set do
      help 'Simple command line tool to run custom perforce actions through subcommands.'
      help 'For more information, please check the help page of the subcommand.'
      help ''
      help "Available subcommands are:\n  #{SUB_COMMANDS.join("\n  ")}"
      help ''
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
  end

  if __FILE__ == $PROGRAM_NAME
    run
  end
end