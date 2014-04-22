module P4Tools
  class CommandEntry
    attr_reader :command, :arguments

    def initialize(command, arguments)
      @command = command
      @arguments = arguments
    end

  end
end