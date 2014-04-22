require_relative 'trollop'
require_relative 'command_options'

module P4Tools
  class CommandParser

    # @param [Array<String>] args
    def initialize(args)
      @raw_args = args
      @parsed_args = {}
    end

    # @return [Hash<Module, Hash<Symbol, Object>>]
    def parse
      parse_global_arguments
      parse_commands

      @parsed_args
    end

    private

    # @return [void]
    def parse_global_arguments
      @parsed_args[P4Tools] = parse_arguments(P4Tools)
    end

    # @return [void]
    def parse_commands
      while command = @raw_args.shift
        command_module = load_module_for_command(command)
        @parsed_args[command_module] = parse_arguments(command_module)
      end
    end

    # @param [Module] command_module
    # @return [Hash<Symbol, Object>]
    def parse_arguments(command_module)
      parser = Trollop::Parser.new
      options = CommandOptions.new(parser)

      command_module.set_options(options)
      parser.stop_on SUB_COMMANDS

      Trollop.with_standard_exception_handling(parser) {
        raise Trollop::HelpNeeded if ARGV.empty? && options.show_help
        parser.parse @raw_args
      }
    end



    # @param [String] command
    # @return [Module]
    def load_module_for_command(command)
      require command
      P4Tools.const_get(Utils.classify(command))
    end

  end
end