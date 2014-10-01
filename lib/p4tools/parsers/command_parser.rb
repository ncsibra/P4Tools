module P4Tools
  class CommandParser

    # @param [Array<String>] args
    def initialize(args)
      @raw_args = args
      @parsed_args = []
    end

    # @return [Array<CommandEntry>]
    def parse
      parse_global_arguments
      parse_commands

      @parsed_args
    end

    private

    # @return [void]
    def parse_global_arguments
      entry = CommandEntry.new(P4Tools, parse_arguments(P4Tools))
      @parsed_args.push(entry)
    end

    # @return [void]
    def parse_commands
      while command = @raw_args.shift
        if SUB_COMMANDS.include?(command)
          command_module = load_module_for_command(command)
          entry = CommandEntry.new(command_module, parse_arguments(command_module))
          @parsed_args.push(entry)
        else
          raise(ArgumentError, "The following subcommand does not exist: '#{command}'")
        end
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