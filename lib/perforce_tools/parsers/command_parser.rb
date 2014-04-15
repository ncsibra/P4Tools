require_relative 'trollop'
require_relative 'command_options'

module PerforceTools
  class CommandParser

    def initialize(args=ARGV)
      @raw_args = args
      @parsed_args = {}
    end

    def parse
      @parsed_args[PerforceTools] = parse_arguments(PerforceTools)
      parse_commands

      @parsed_args
    end

    private

    def parse_commands
      while command = @raw_args.shift
        cmodule = load_module_for_command(command)
        @parsed_args[cmodule] = parse_arguments(cmodule)
      end
    end

    def parse_arguments(cmodule)
      parser = Trollop::Parser.new
      options = CommandOptions.new(parser)
      cmodule.set_options(options)
      parser.stop_on SUB_COMMANDS

      Trollop.with_standard_exception_handling(parser) { parser.parse @raw_args }
    end

    def load_module_for_command(command)
      require command
      eval("PerforceTools::#{Utils.classify(command)}")
    end

  end
end