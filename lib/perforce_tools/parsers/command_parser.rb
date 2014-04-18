require_relative 'trollop'
require_relative 'command_options'

module PerforceTools
  class CommandParser

    def initialize(args)
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
        command_module = load_module_for_command(command)
        @parsed_args[command_module] = parse_arguments(command_module)
      end
    end

    def parse_arguments(command_module)
      options = CommandOptions.new
      command_module.set_options(options)
      parser = options.instance_eval { get_parser }

      Trollop.with_standard_exception_handling(parser) { parser.parse @raw_args }
    end

    def load_module_for_command(command)
      require command
      PerforceTools.const_get(Utils.classify(command))
    end

  end
end