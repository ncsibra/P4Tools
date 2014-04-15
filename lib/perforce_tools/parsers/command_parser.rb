require_relative 'trollop'
require_relative 'command_options'

class CommandParser

  def initialize
    @args = {}
  end

  def parse
    @args[PerforceTools] = parse_arguments(PerforceTools)
    parse_commands

    @args
  end

  private

  def parse_commands
    while command = ARGV.shift
      cmodule = load_module_for_command(command)
      @args[cmodule] = parse_arguments(cmodule)
    end
  end

  def parse_arguments(cmodule)
    parser = Trollop::Parser.new
    options = CommandOptions.new(parser)
    cmodule.set_options(options)
    parser.stop_on SUB_COMMANDS

    Trollop.with_standard_exception_handling(parser) { parser.parse ARGV }
  end

  def load_module_for_command(command)
    require command
    Module.const_get(Utils.classify(command))
  end

end
