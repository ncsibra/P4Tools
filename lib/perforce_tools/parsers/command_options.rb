module PerforceTools
  class CommandOptions

    def initialize
      @parser = Trollop::Parser.new
    end

    def help(text)
      @parser.banner(text)
    end

    def arg(name, desc='', options={})
      @parser.opt(name, desc, options)
    end

    def set(&opts)
      self.instance_eval &opts
    end

    private
    def get_parser
      @parser.stop_on SUB_COMMANDS
      @parser
    end

  end
end