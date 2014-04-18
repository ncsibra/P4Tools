module PerforceTools
  class CommandOptions

    def initialize(parser)
      @parser = parser
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

  end
end